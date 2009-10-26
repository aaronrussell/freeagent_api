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
  #   contact = Contact.new params
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
    
#    def self.find(*args)
#      opts = args.slice(1) || {}
#      self.prefix = "/projects/#{opts[:params][:project_id]}/" if opts[:params] && opts[:params][:project_id]
#      super
#    end
    
  end

end