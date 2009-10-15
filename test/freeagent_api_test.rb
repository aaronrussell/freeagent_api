require 'test_helper'
require 'yaml'

class FreeagentApiTest < Test::Unit::TestCase
  
  include Freeagent
  
  context "Before we do anything, we" do
    setup do
      @config ||= YAML.load_file 'test/user_credentials.yaml'
    end
    should "set the domain" do
      assert Freeagent.domain = @config['domain']
    end
    should "set the username" do
      assert Freeagent.username = @config['username']
    end
    should "set the password" do
      assert Freeagent.password = @config['password']
    end
  end
  
  context "Many projects" do
    setup do
      @projects = Project.find_all
    end
    should "be in an array" do
      assert @projects.is_a? Array
    end
  end
  
end
