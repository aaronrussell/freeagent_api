require 'test_helper'

class InvoiceItemTest < Test::Unit::TestCase
  
  fake_it_all
  
  context "InvoiceItem class" do
    should "has correct collection path" do
      assert_equal '/invoices/1000/invoice_items.xml', InvoiceItem.collection_path(:invoice_id => 1000)
    end
    should "has correct element path" do
      assert_equal '/invoices/1000/invoice_items/first.xml', InvoiceItem.element_path(:first, :invoice_id => 1000)
      assert_equal '/invoices/1000/invoice_items/1.xml', InvoiceItem.element_path(1, :invoice_id => 1000)
    end
  end
  
  context "Invoice Items" do
    setup do
      @invoice_items = InvoiceItem.find :all, :params => {:invoice_id => 73867}
    end
    should "return an array" do
      assert @invoice_items.is_a? Array
    end
    should "return Invoices" do
      assert_equal 3, @invoice_items.size
      assert @invoice_items.first.is_a? InvoiceItem
    end
  end
  
  context "Invoice Item" do
    setup do
      @invoice_item = InvoiceItem.find 169399, :params => {:invoice_id => 73867}
    end
    should "return a Invoice Item" do
      assert @invoice_item.is_a? InvoiceItem
    end
    should "update and save" do
      @invoice_item.description = 'Create wireframe templates'
      assert @invoice_item.save
    end
    should "be destroyed" do
      assert @invoice_item.destroy
    end
  end
  
  #TODO - Add test for invalid resource
  # Need support from fakeweb in order to achieve this
  
  context "New Invoice Item" do
    setup do
      params = {
        :item_type      => 'Hours',
        :description    => 'Create wireframe templates',
        :quantity       => '12',
        :price          => '50',
        :sales_tax_rate => '15',
        :invoice_id     => '73867'
      }
      @invoice_item = InvoiceItem.new params
    end
    should "validate and save" do
      assert @invoice_item.save_with_validation
    end
  end
    
end