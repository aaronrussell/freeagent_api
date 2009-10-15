require 'rubygems'
require 'nokogiri'
require 'net/https'
require 'api_cache'
require 'activesupport'
require 'activeresource'

# Require Freeagent library files
Dir[File.join(File.dirname(__FILE__), "freeagent/*.rb")].each { |f| require f }

module Freeagent
  
  class << self
    attr_accessor :domain, :username, :password

    def self.domain=(domain)
      @domain = domain
    end

    def self.username=(username)
      @username = username
    end

    def self.password=(password)
      @password = password
    end
  end
  
end