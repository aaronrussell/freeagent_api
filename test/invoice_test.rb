require 'test_helper'

class InvoiceTest < Test::Unit::TestCase
  
  fake_it_all
  
  context "Invoice class" do
    should "has correct collection path" do
      assert_equal '/projects/1000/invoices.xml', Invoice.collection_path(:project_id => 1000)
    end
    should "has correct element path" do
      assert_equal '/projects/1000/invoices/first.xml', Invoice.element_path(:first, :project_id => 1000)
      assert_equal '/projects/1000/invoices/1.xml', Invoice.element_path(1, :project_id => 1000)
    end
  end
  
#  context "Contacts" do
#    setup do
#      @contacts = Contact.find :all
#    end
#    should "return an array" do
#      assert @contacts.is_a? Array
#    end
#    should "return Contacts" do
#      assert_equal 16, @contacts.size
#      assert @contacts.first.is_a? Contact
#    end
#  end
  
#  context "Contact" do
#    setup do
#      @contact = Contact.find 27309
#    end
#    should "return a Contact" do
#      assert @contact.is_a? Contact
#    end
#    should "update and save" do
#      @contact.last_name = 'Roberts'
#      assert @contact.save
#    end
#    should "be destroyed" do
#      assert @contact.destroy
#    end
#  end
  
  #TODO - Add test for invalid resource
  # Need support from fakeweb in order to achieve this
  
#  context "New Contact" do
#    setup do
#      params = {
#        :first_name => 'Fred',
#        :last_name  => 'Bloggs'
#      }
#      @new_contact = Contact.new params
#    end
#    should "validate and save" do
#      assert @new_contact.save_with_validation
#    end
#  end
    
end