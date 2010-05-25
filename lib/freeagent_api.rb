require 'rubygems'
gem 'activeresource', '< 3.0.0.beta1'
require 'active_resource'

module Freeagent
  
  class << self
    def authenticate(options)
      Base.authenticate(options)
    end
  end
  
  class Error < StandardError; end

  class Base < ActiveResource::Base
    def self.authenticate(options)
      self.site = "https://#{options[:domain]}"
      self.user = options[:username]
      self.password = options[:password]
    end
  end
  
  # Company
    
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
  
  # Contacts
  
  class Contact < Base
  end
  
  # Projects
  
  class Project < Base

    def invoices
      Invoice.find :all, :from => "/projects/#{id}/invoices.xml"
    end
        
    def timeslips
      Timeslip.find :all, :from => "/projects/#{id}/timeslips.xml"
    end

  end
  
  # Tasks - Complete
  
  class Task < Base
    self.prefix = '/projects/:project_id/'        
  end
  
  # Invoices - Complete
  
  class Invoice < Base
    
    def mark_as_draft
      connection.put("/invoices/#{id}/mark_as_draft.xml", encode, self.class.headers).tap do |response|
        load_attributes_from_response(response)
      end
    end
    def mark_as_sent
      connection.put("/invoices/#{id}/mark_as_sent.xml", encode, self.class.headers).tap do |response|
        load_attributes_from_response(response)
      end
    end
    def mark_as_cancelled
      connection.put("/invoices/#{id}/mark_as_cancelled.xml", encode, self.class.headers).tap do |response|
        load_attributes_from_response(response)
      end
    end
    
  end
  
  # Invoice items - Complete
  
  class InvoiceItem < Base
    self.prefix = '/invoices/:invoice_id/'
  end

  # Timeslips
  
  class Timeslip < Base
    
    def self.find(*arguments)
      scope   = arguments.slice!(0)
      options = arguments.slice!(0) || {}
      if options[:params] && options[:params][:from] && options[:params][:to]
        options[:params][:view] = options[:params][:from]+'_'+options[:params][:to]
        options[:params].delete(:from)
        options[:params].delete(:to)
      end

      case scope
        when :all   then find_every(options)
        when :first then find_every(options).first
        when :last  then find_every(options).last
        when :one   then find_one(options)
        else             find_single(scope, options)
      end
    end    
  end
  
  # Users
  
  class User < Base
    self.prefix = '/company/'
    def self.find_by_email(email)
      users = User.find :all
      users.each do |u|
        u.email == email ? (return u) : next
      end
      raise Error, "No user matches that email!"
    end
  end
  
end