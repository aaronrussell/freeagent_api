require 'test_helper'

class TimeslipTest < Test::Unit::TestCase
  
  context "Timeslip class" do
    should "have correct collection path" do
      assert_equal '/timeslips.xml', Timeslip.collection_path
    end
    should "have correct element path" do
      assert_equal '/timeslips/first.xml', Timeslip.element_path(:first)
      assert_equal '/timeslips/1000.xml', Timeslip.element_path(1000)
    end
  end
  
  context "Timeslips" do
    setup do
      @timeslips = Timeslip.find :all, :params => {:view => '2009-10-01_2009-10-10'}
    end
    should "return an array" do
      assert @timeslips.is_a? Array
    end
    should "return Timeslips" do
      assert_equal 5, @timeslips.size
      assert @timeslips.first.is_a? Timeslip
    end
  end
    
  context "Timeslip" do
    setup do
      @timeslip = Timeslip.find 84445
    end
    should "return a Invoice" do
      assert @timeslip.is_a? Timeslip
    end
    should "update and save" do
      @timeslip.hours = '10'
      assert @timeslip.save
    end
    should "be destroyed" do
      assert @timeslip.destroy
    end
  end
  
  #TODO - Add test for invalid resource
  # Need support from fakeweb in order to achieve this
  
  context "New Timeslip" do
    setup do
      params = {
        :user_id    => '5193',
        :hours => '4',
        :dated_on => '2009-10-05T00:00:00Z',
        :task_id => '12683',
      }
      @timeslip = Timeslip.new params
    end
    should "validate and save" do
      assert @timeslip.save_with_validation
    end
  end
    
end