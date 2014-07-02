lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json'
require 'sinatra/base'
require 'nokogiri'

class TestingServer < Sinatra::Base

  set :raise_errors, true

  get  '/hello_world' do
    request.accept.each do |type|
      case type.to_s
      when 'application/json'
        output = {greeting: 'Hello World!'}.to_json
      when 'application/xml'
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.root {
            xml.greeting {
              xml << "Hello World!"
            }
          }
        end
        output = builder.to_xml
      end
      halt output
    end
    error 406
  end

  post '/send_data' do
    put_post_response
  end

  put '/put' do
    put_post_response
  end

  def put_post_response
    data = request.body.read
    request.accept.each do |type|
      case type.to_s
      when 'application/json'
        content_type :json
        #if we get json we can parse it!
        output = JSON.parse(data).to_json
      when 'application/xml'
        content_type :xml
        #in-valid xml will raise an exception
        xml = Nokogiri::XML(data){|config| config.strict}
        puts xml.to_xml
        output = xml.to_s
      end
      halt output
    end
    error 406
  end

end

run TestingServer.new
