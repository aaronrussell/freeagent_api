require 'test_helper'

class FreeagentApiTest < Test::Unit::TestCase
  
  context "Authentication details" do
    should "match what was set" do
      assert_equal URI.parse('https://testuser.freeagentcentral.com'), Base.site
      assert_equal 'testuser', Base.user
      assert_equal 'testpass', Base.password
    end
  end
  
end
