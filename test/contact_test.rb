require 'test_helper'

class ContactTest < Test::Unit::TestCase
  
  fake_it_all
  
  context "Contact class" do
    should "has correct collection path" do
      assert_equal '/contacts.xml', Contact.collection_path
    end
    should "has correct element path" do
      assert_equal '/contacts/first.xml', Contact.element_path(:first)
      assert_equal '/contacts/1.xml', Contact.element_path(1)
    end
  end
  
  context "Contacts" do
    setup do
      @contacts = Contact.find :all
    end
    should "return an array" do
      assert @contacts.is_a? Array
    end
    should "return Contacts" do
      assert_equal 16, @contacts.size
      assert @contacts.first.is_a? Contact
    end
  end
  
  context "Contact" do
    setup do
      @contact = Contact.find 27309
    end
    should "return a Contact" do
      assert @contact.is_a? Contact
    end
    should "update and save" do
      @contact.last_name = 'Roberts'
      assert @contact.save
    end
    should "be destroyed" do
      assert @contact.destroy
    end
  end
  
  #TODO - Add test for invalid resource
  # Need support from fakeweb in order to achieve this
  
  context "New Contact" do
    setup do
      params = {
        :first_name => 'Fred',
        :last_name  => 'Bloggs'
      }
      @new_contact = Contact.new params
    end
    should "validate and save" do
      assert @new_contact.save_with_validation
    end
  end
    
end