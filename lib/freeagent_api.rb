require 'rubygems'
require 'nokogiri'
require 'net/https'
require 'api_cache'
require 'activesupport'

module Freeagent
  
  class << self
    attr_accessor :domain, :username, :password

    def self.domain=(domain)
      @domain = domain
    end

    def self.username=(username)
      @username = username
    end

    def self.password=(password)
      @password = password
    end
  end
  
  class Base
    
    def initialize(attributes={})
      attributes.each do |key, value|
        raise "no attr_accessor set for #{key} on #{self.class}" if !respond_to?("#{key}=")
        self.send("#{key}=", value)
      end
    end
    
    def self.get(path)
      @@resp = APICache.get(path) do
        http = Net::HTTP.new(Freeagent.domain, 443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.start do |http|
          request = Net::HTTP::Get.new(path, {'Content-Type' => 'application/xml', 'Accept' => 'application/xml'})
          request.basic_auth(Freeagent.username, Freeagent.password)
          response = http.request(request)
          case response
          when Net::HTTPSuccess
            @@resp = response.body
          else
            response.error!
            raise APICache::InvalidResponse
          end
        end
      end
    end
    
    def self.parse(path, options)
      response = []
      Nokogiri::XML(@@resp).xpath(path).each do |ts|
        res = {}
        options.each do |key|
          res[key.underscore.to_sym] = ts.xpath(key).text
        end
        response << self.new(res)
      end
      return response
    end
    
  end
  
  class Contact < Base
    @elements = ['id', 'organisation-name', 'first-name', 'last-name', 'address1', 'address2', 'address3', 'town', 'region', 'country', 'postcode', 'phone-number', 'email', 'contact-name-on-invoices', 'sales-tax-registration_number', 'uses-contact-invoice-sequence']
    @elements.each {|t| attr_accessor t.underscore.to_sym}
    
    def self.find_all
      get '/contacts'
      contacts = parse('contacts/contact', @elements)
      return contacts
    end
    
    def self.find(contact_id)
      get '/contacts/'+contact_id
      contacts = parse('contact', @elements)
      return contacts[0]
    end
  end
  
  class Invoice < Base
    @elements = ['id', 'contact-id', 'project-id', 'dated-on', 'due-on', 'reference', 'net-value', 'sales-tax-value', 'status', 'comments', 'discount-percent', 'omit-header', 'payment-terms', 'written-off-date', 'invoice-items']
    @elements.each {|t| attr_accessor t.underscore.to_sym}
    
    def self.find_all(project_id = false)
      if project_id
        get '/projects/'+project_id+'/invoices' 
      else
        get '/invoices'
      end
      invoices = parse('invoices/invoice', @elements)
      return invoices.reverse
    end
    
    def self.find(invoice_id)
      get '/invoices/'+invoice_id
      invoices = parse('invoice', @elements)
      invoices.each do |i|
        i.invoice_items = InvoiceItem.find_all(invoice_id)
      end
      return invoices[0]
    end
  end
  
  class InvoiceItem < Invoice
    @elements = ['id', 'invoice-id', 'project-id', 'item-type', 'price', 'quantity', 'description', 'sales-tax-rate']
    @elements.each {|t| attr_accessor t.underscore.to_sym}

    def self.find_all(invoice_id)
      items = parse('invoice/invoice-items/invoice-item', @elements)
      return items
    end
  end
  
  class Project < Base
    @elements = ['id', 'contact-id', 'name', 'billing-basis', 'budget', 'budget-units', 'invoicing-reference', 'is-ir35', 'normal-billing-rate', 'payment-terms-in-days', 'starts-on', 'ends-on', 'status', 'uses-project-invoice-sequence']
    @elements.each {|t| attr_accessor t.underscore.to_sym}
    
    def self.find_all
      get '/projects'
      projects = parse('projects/project', @elements)
      return projects
    end
    
    def self.find(project_id)
      get '/projects/'+project_id
      projects = parse('project', @elements)
      return projects[0]
    end
  end
  
  class Task < Base
    @elements = ['id', 'project-id', 'name']
    @elements.each {|t| attr_accessor t.underscore.to_sym}

    def self.find(project_id, task_id)
      get '/projects/'+project_id+'/tasks/'+task_id
      tasks = parse('task', @elements)
      return tasks[0]
    end
  end
  
  class Timeslip < Base
    @elements = ['id', 'dated-on', 'project-id', 'task-id', 'task', 'user-id', 'hours', 'comment']
    @elements.each {|t| attr_accessor t.underscore.to_sym}

    def self.find_all(project_id = false)
      if project_id
        get '/projects/'+project_id+'/timeslips'
      else
        get '/timeslips'
      end
      timeslips = parse('timeslips/timeslip', @elements)
      timeslips.each do |t|
        t.task = Task.find(project_id, t.task_id)
      end
      return timeslips.reverse
    end
    
    def self.find(timeslip_id)
      get '/timeslips'+timeslip_id
      timeslips = parse('timeslip', @elements)
      return timeslips[0]
    end
  end
  
  
end