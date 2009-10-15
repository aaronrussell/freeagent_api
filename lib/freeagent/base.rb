module Freeagent

  class Base
  
    def initialize(attributes={})
      attributes.each do |key, value|
        raise "no attr_accessor set for #{key} on #{self.class}" if !respond_to?("#{key}=")
        self.send("#{key}=", value)
      end
    end
  
    def self.get(path)
      @@resp = APICache.get(path) do
        http = Net::HTTP.new(Freeagent.domain, 443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.start do |http|
          request = Net::HTTP::Get.new(path, {'Content-Type' => 'application/xml', 'Accept' => 'application/xml'})
          request.basic_auth(Freeagent.username, Freeagent.password)
          response = http.request(request)
          case response
          when Net::HTTPSuccess
            @@resp = response.body
          else
            response.error!
            raise APICache::InvalidResponse
          end
        end
      end
    end
  
    def self.parse(path, options)
      response = []
      Nokogiri::XML(@@resp).xpath(path).each do |ts|
        res = {}
        options.each do |key|
          res[key.underscore.to_sym] = ts.xpath(key).text
        end
        response << self.new(res)
      end
      return response
    end
  
  end

end