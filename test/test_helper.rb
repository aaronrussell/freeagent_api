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
  
  site_url = 'https://testuser:testpass@testuser.freeagentcentral.com'
  
  # GET URLs
  { '/company/invoice_timeline.xml' => File.join('company', 'invoice_timeline'),
    '/company/tax_timeline.xml'     => File.join('company', 'tax_timeline'),
    '/contacts.xml'                 => File.join('contacts', 'find_all'),
    '/contacts/27309.xml'           => File.join('contacts', 'find_single'),
    '/projects.xml'                 => File.join('projects', 'find_all'),
    '/projects/17820.xml'           => File.join('projects', 'find_single'),
    '/projects/17820/invoices.xml'  => File.join('invoices', 'find_all')
  }.each do |path, stub|
    FakeWeb.register_uri(:get, site_url+path, :response => stub_file(stub))
  end
  
  # POST URLs
  { '/contacts.xml'                 => File.join('http', '201'),
    '/projects.xml'                 => File.join('http', '201')
  }.each do |path, stub|
    FakeWeb.register_uri(:post, site_url+path, :response => stub_file(stub))
  end
  
  # PUT URLs
  { '/contacts/27309.xml'           => File.join('http', '200'),
    '/projects/17820.xml'           => File.join('http', '200')
  }.each do |path, stub|
    FakeWeb.register_uri(:put, site_url+path, :response => stub_file(stub))
  end
  
  # DELETE URLs
  { '/contacts/27309.xml'           => File.join('http', '200'),
    '/projects/17820.xml'           => File.join('http', '200')
  }.each do |path, stub|
    FakeWeb.register_uri(:delete, site_url+path, :response => stub_file(stub))
  end

end

class Test::Unit::TestCase
end
