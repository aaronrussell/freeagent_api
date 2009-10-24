require 'rubygems'
require 'activeresource'

module Freeagent
  
  class << self
    attr_accessor :domain, :username, :password
  end
  
  class Error < StandardError; end

  class Base < ActiveResource::Base
    def self.authenticate
      self.site = "https://#{Freeagent.domain}"
      self.user = Freeagent.username
      self.password = Freeagent.password
    end
  end
  
  # Company.invoice_timeline
  # Company.tax_timeline
  
  class Company
    def self.invoice_timeline
      InvoiceTimeline.find :all, :from => '/company/invoice_timeline.xml'
    end
    def self.tax_timeline
      TaxTimeline.find :all, :from => '/company/tax_timeline.xml'
    end
  end
  class InvoiceTimeline < Base
    self.prefix = '/company/'
  end
  class TaxTimeline < Base
    self.prefix = '/company/'
  end
  
  # Find contacts
  #
  #   Contact.find :all         # find all contacts
  #   Contact.find contact_id   # find specific contact by ID
  #
  # Create contact
  #
  #   Required attributes
  #     :first_name
  #     :last_name
  #
  #   contact = Contact.new :first_name => 'Joe', :last_name => 'Bloggs'
  #   contact.save
  #
  # Update contact
  #
  #   contact = Contact.find contact_id
  #   contact.first_name = 'Joe'
  #   contact.last_name = 'Bloggs'
  #   contact.save
  #
  # Delete contact
  #
  #   Contact.delete contact_id
  #   contact.destroy
  #
  
  class Contact < Base
  end
  
  # Find projects
  #
  #   Project.find :all         # find all projects
  #   Project.find project_id   # find specific project by ID
  #
  # Create project
  #
  #   Required attributes
  #     :contact_id
  #     :name
  #     :payment_term_in_days
  #     :billing_basis          # must be 1, 7, 7.5, or 8
  #     :budget_units           # must be Hours, Days, or Monetary
  #     :status                 # must be Active or Completed
  #
  #   Project = Project.new params
  #   contact.save
  #
  # Update project
  #
  #   project = Project.find project_id
  #   project.name = 'Website redesign and build'
  #   project.save
  #
  # Delete project
  #
  #   Project.delete project_id
  #   project.destroy
  #
  
  class Project < Base

    def invoices
      Invoice.find :all, :params => {:project_id => id}
    end
    
    def tasks
      Task.find :all, :params => {:project_id => id}
    end
    
    def timeslips
      Timeslip.find :all, :params => {:project_id => id}
    end

  end
  
  # Find invoices
  #
  #   Invoice.find :all, :params => {:project_id => project_id}
  #   Invoice.find task_id
  #   
  #TODO Create invoice
  #
  #TODO Update invoice
  #
  #TODO Delete project
  #
  ##TODO add Change status methods
  # /invoices/invoice_id/mark_as_draft
  # /invoices/invoice_id/mark_as_sent
  # /invoices/invoice_id/mark_as_cancelled

  
  class Invoice < Base
    self.prefix = '/projects/:project_id/'
  end
  
  # Find invoice items
  #
  #   InvoiceItem.find :all, :params => {:invoice_id => invoice_id}
  #   InvoiceItem.find invoice_item_id, :params => {:invoice_id => invoice_id}
  #
  #TODO Create invoice item
  #
  
  class InvoiceItem < Base
    self.prefix = '/invoices/:invoice_id/'
  end
  
  # Find tasks
  #
  #   Task.find :all
  #   Task.find :all, :params => {:project_id => project_id}
  #   Task.find task_id
  #
  #TODO Create task
  #
  #TODO Update task
  #
  #TODO Delete project
  #
  
  class Task < Base
    
    self.prefix = '/projects/:project_id/'
    
#    def self.find(*args)
#      opts = args.slice!(1) || {}
#      self.prefix = "/projects/#{opts[:params][:project_id]}/" if opts[:params] && opts[:params][:project_id]
#      super
#    end
        
  end
  
  # Find timeslips
  #
  #   Timeslip.find :all, :params => {:view => '2009-01-01_2009-10-01'}
  #   Timeslip.find :all, :params => {:project_id => project_id}
  #   Timeslip.find :timeslip_id
  
  
  class Timeslip < Base
    
    def self.find(*args)
      opts = args.slice!(1) || {}
      self.prefix = "/projects/#{opts[:params][:project_id]}/" if opts[:params] && opts[:params][:project_id]
      super
    end
    
  end
  
  ####################################################################################
  
  
  class ActiveResource::Connection
   def http
     http = Net::HTTP.new(@site.host, @site.port)
     http.use_ssl = @site.is_a?(URI::HTTPS)
     http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl
     http.read_timeout = @timeout if @timeout
     #Here's the addition that allows you to see the output
     http.set_debug_output $stderr
     return http
   end
  end

end