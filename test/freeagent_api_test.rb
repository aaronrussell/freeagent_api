require 'test_helper'

class FreeagentApiTest < Test::Unit::TestCase
  
  context "Authentication details" do
    should "match what was set" do
      assert_equal Base.site, URI.parse('https://testuser.freeagentcentral.com')
      assert_equal Base.user, 'testuser'
      assert_equal Base.password, 'testpass'
    end
  end
  
end
