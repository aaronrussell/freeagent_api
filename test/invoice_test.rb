require 'test_helper'

class InvoiceTest < Test::Unit::TestCase
  
  fake_it_all
  
  context "Invoice class" do
    should "has correct collection path" do
      assert_equal '/invoices.xml', Invoice.collection_path
    end
    should "has correct element path" do
      assert_equal '/invoices/first.xml', Invoice.element_path(:first)
      assert_equal '/invoices/1.xml', Invoice.element_path(1)
    end
  end
  
  context "Invoices" do
    setup do
      @invoices = Invoice.find :all
    end
    should "return an array" do
      assert @invoices.is_a? Array
    end
    should "return Invoices" do
      assert_equal 7, @invoices.size
      assert @invoices.first.is_a? Invoice
    end
  end
  
  context "Invoice" do
    setup do
      @invoice = Invoice.find 73867
    end
    should "return a Invoice" do
      assert @invoice.is_a? Invoice
    end
    should "update and save" do
      @invoice.last_name = 'Roberts'
      assert @invoice.save
    end
    should "be destroyed" do
      assert @invoice.destroy
    end
    should "change status" do
      assert @invoice.mark_as_draft
      assert @invoice.mark_as_sent
      assert @invoice.mark_as_cancelled
    end
  end
  
  #TODO - Add test for invalid resource
  # Need support from fakeweb in order to achieve this
  
  context "New Invoice" do
    setup do
      params = {
        :contact_id => '29899',
        :project_id => '21445',
        :dated_on   => '2009-10-26T00:00:00Z',
        :reference  => 'INV100',
        :status     => 'Draft'
      }
      @invoice = Invoice.new params
    end
    should "validate and save" do
      assert @invoice.save_with_validation
    end
  end
    
end