require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'fakeweb'
require 'pp'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'freeagent_api'
include Freeagent

Freeagent.authenticate({
  :domain => 'testuser.freeagentcentral.com',
  :username => 'testuser',
  :password => 'testpass'})

FakeWeb.allow_net_connect = false

def stub_file(path)
  File.join(File.dirname(__FILE__), 'stubs', path)
end

def fake_it_all
  FakeWeb.clean_registry
  
  site_url = 'https://testuser:testpass@testuser.freeagentcentral.com'
  
  # GET URLs
  { '/company/invoice_timeline.xml'             => File.join('company', 'invoice_timeline'),
    '/company/tax_timeline.xml'                 => File.join('company', 'tax_timeline'),
    '/contacts.xml'                             => File.join('contacts', 'find_all'),
    '/contacts/27309.xml'                       => File.join('contacts', 'find_single'),
    '/projects.xml'                             => File.join('projects', 'find_all'),
    '/projects/17820.xml'                       => File.join('projects', 'find_single'),
    '/projects/17820/tasks.xml'                 => File.join('tasks', 'find_all'),
    '/projects/17820/tasks/13161.xml'           => File.join('tasks', 'find_single'),
    '/invoices.xml'                             => File.join('invoices', 'find_all'),
    '/invoices/73867.xml'                       => File.join('invoices', 'find_single'),
    '/projects/17820/invoices.xml'              => File.join('projects', 'invoices'),
    '/invoices/73867/invoice_items.xml'         => File.join('invoice_items', 'find_all'),
    '/invoices/73867/invoice_items/169399.xml'  => File.join('invoice_items', 'find_single'),
    '/timeslips.xml?view=2009-10-01_2009-10-10' => File.join('timeslips', 'find_all'),
    '/timeslips/84445.xml'                      => File.join('timeslips', 'find_single'),
    '/projects/17820/timeslips.xml'             => File.join('projects', 'timeslips'),
    '/company/users.xml'                        => File.join('users', 'find_all'),
    '/company/users/11.xml'                     => File.join('users', 'find_single')
  }.each do |path, stub|
    FakeWeb.register_uri(:get, site_url+path, :response => stub_file(stub))
  end
  
  # POST URLs
  { '/contacts.xml'                     => File.join('http', '201'),
    '/projects.xml'                     => File.join('http', '201'),
    '/projects/17820/tasks.xml'         => File.join('http', '201'),
    '/invoices.xml'                     => File.join('http', '201'),
    '/invoices/73867/invoice_items.xml' => File.join('http', '201'),
    '/timeslips.xml'                    => File.join('http', '201'),
    '/company/users.xml'                => File.join('http', '201')
  }.each do |path, stub|
    FakeWeb.register_uri(:post, site_url+path, :response => stub_file(stub))
  end
  
  # PUT URLs
  { '/contacts/27309.xml'                       => File.join('http', '200'),
    '/projects/17820.xml'                       => File.join('http', '200'),
    '/projects/17820/tasks/13161.xml'           => File.join('http', '200'),
    '/invoices/73867.xml'                       => File.join('http', '200'),
    '/invoices/73867/mark_as_draft.xml'         => File.join('http', '200'),
    '/invoices/73867/mark_as_sent.xml'          => File.join('http', '200'),
    '/invoices/73867/mark_as_cancelled.xml'     => File.join('http', '200'),
    '/invoices/66913.xml'                       => File.join('http', '200'),
    '/invoices/73867/invoice_items/169399.xml'  => File.join('http', '200'),
    '/timeslips/84445.xml'                      => File.join('http', '200'),
    '/timeslips/74814.xml'                      => File.join('http', '200'),
    '/company/users/11.xml'                     => File.join('http', '200')
  }.each do |path, stub|
    FakeWeb.register_uri(:put, site_url+path, :response => stub_file(stub))
  end
  
  # DELETE URLs
  { '/contacts/27309.xml'                       => File.join('http', '200'),
    '/projects/17820.xml'                       => File.join('http', '200'),
    '/projects/17820/tasks/13161.xml'           => File.join('http', '200'),
    '/invoices/73867.xml'                       => File.join('http', '200'),
    '/invoices/66913.xml'                       => File.join('http', '200'),
    '/invoices/73867/invoice_items/169399.xml'  => File.join('http', '200'),
    '/timeslips/84445.xml'                      => File.join('http', '200'),
    '/timeslips/74814.xml'                      => File.join('http', '200'),
    '/company/users/11.xml'                     => File.join('http', '200')
  }.each do |path, stub|
    FakeWeb.register_uri(:delete, site_url+path, :response => stub_file(stub))
  end

end

class Test::Unit::TestCase
end
