require_relative '../spec_helper'

#NOTE: tests require the server to be running. I use the shotgun gem but any rack server should work just run on port 9393 as its hardcoded below. (A sinatra app is created for these tests in config.ru)

class CurbClient
  include SimpleApiClient

  # format can be :json or :xml (defaults to :json)
  def hello_world format
    call(
      method: :get,
      uri: uri('/hello_world'),
      accept: format
    )
  end

  # format can be :json or :xml (defaults to :json)
  def send_data payload, format
    call(
      method: :post,
      uri: uri('/send_data'),
      payload: payload,
      accept: format
    )
  end

  # format can be :json or :xml (defaults to :json)
  def put payload, format
    call(
      method: :put,
      uri: uri('/put'),
      payload: payload,
      accept: format
    )
  end
end

describe HttpCaller::Curb do

  subject { CurbClient.new('//127.0.0.1:9393/', HttpCaller::Curb.new) }

  it '#call - a get request to /hello_world works when requesting json' do
    result = subject.hello_world(:json)
    JSON.parse(result.body)['greeting'].must_equal 'Hello World!'
  end

  it '#call - a get request to /hello_world works when requesting xml' do
    result = subject.hello_world :xml
    xml = Nokogiri::XML(result.body)
    xml.at_xpath('//greeting').content.must_equal 'Hello World!'
  end

  it '#call - a post request to /send_data works when sending json' do
    put_post_json_test
  end

  it '#call - a post request to /send_data works when sending xml' do
    put_post_xml_test
  end

  it '#call - a put request to /put works when sending json' do
    put_post_json_test
  end

  it '#call - a put request to /put works when sending xml' do
    put_post_xml_test
  end

  private

  def put_post_json_test
    data = {"my_data" => "Is very simple"}
    result = subject.put data.to_json, :json
    assert JSON.parse(result.body).must_equal data
  end

  def put_post_xml_test
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.root {
        xml.data {
          xml << "My data!"
        }
      }
    end

    result = subject.send_data builder.to_xml, :xml
    xml = Nokogiri::XML(result.body)
    xml.at_xpath('//data').content.must_equal 'My data!'
  end

end
