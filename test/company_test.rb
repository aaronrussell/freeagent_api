require 'test_helper'

class CompanyTest < Test::Unit::TestCase
  
  fake_it_all
    
  context "Invoice timeline" do
    setup do
      @inv_timeline = Company.invoice_timeline
    end
    should "return an array" do
      assert @inv_timeline.is_a? Array
    end
    should "return invoice timeline items" do
      assert_equal 12, @inv_timeline.size
      assert @inv_timeline.first.is_a? InvoiceTimeline
    end    
  end
  
  context "Tax timeline" do
    setup do
      @tax_timeline = Company.tax_timeline
    end
    should "return an array" do
      assert @tax_timeline.is_a? Array
    end
    should "return projects" do
      assert_equal 3, @tax_timeline.size
      assert @tax_timeline.first.is_a? TaxTimeline
    end    
  end
    
end