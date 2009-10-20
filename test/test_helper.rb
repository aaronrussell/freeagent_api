require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'fakeweb'
require 'pp'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'freeagent_api'
include Freeagent

Freeagent.domain    = 'testuser.freeagentcentral.com'
Freeagent.username  = 'testuser'
Freeagent.password  = 'testpass'

Base.authenticate

FakeWeb.allow_net_connect = false

def stub_file(path)
  File.join(File.dirname(__FILE__), 'stubs', path)
end

def fake_it_all
  FakeWeb.clean_registry
  fakes = {
    "/projects.xml"     => File.join('projects', 'get'),
    "/projects/17820.xml"   => File.join('projects', 'get_17820')
  }
  fakes.each do |path, stub|
    FakeWeb.register_uri(:get, 'https://testuser:testpass@testuser.freeagentcentral.com'+path, :response => stub_file(stub))
  end
end

class Test::Unit::TestCase
end
