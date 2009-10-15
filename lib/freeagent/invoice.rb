module Freeagent

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

end