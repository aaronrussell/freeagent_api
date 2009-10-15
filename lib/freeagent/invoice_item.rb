module Freeagent

  class InvoiceItem < Invoice
    @elements = ['id', 'invoice-id', 'project-id', 'item-type', 'price', 'quantity', 'description', 'sales-tax-rate']
    @elements.each {|t| attr_accessor t.underscore.to_sym}

    def self.find_all(invoice_id)
      items = parse('invoice/invoice-items/invoice-item', @elements)
      return items
    end
  end

end