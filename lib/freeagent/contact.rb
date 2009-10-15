module Freeagent

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

end