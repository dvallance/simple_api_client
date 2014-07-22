require_relative 'spec_helper'

class TestClient
  include SimpleApiClient
end

class TestCaller
  def call(opts)
  end
end

describe TestClient do

  it '#initialize expects a valid uri string' do
    err = proc {
      TestClient.new(nil, nil)
    }.must_raise ArgumentError

    assert err.to_s =~ /expected URI/, 'wrong Argument error'
  end

  it '#initialize expects a valid uri string containg a host' do
    err = proc {
      TestClient.new('not_valid', nil)
    }.must_raise ArgumentError

    err.to_s.must_equal TestClient::ARGUMENT_ERROR_MESSAGE_HOST_MISSING
  end

  it '#initialize expects a http_client that response to :call' do
    err = proc {
     TestClient.new('//www.test.com', nil)
    }.must_raise ArgumentError

    err.to_s.must_equal TestClient::ARGUMENT_ERROR_MESSAGE_RESPOND_TO_CALL_NEEDED
  end

  it "#initialize works with valid parameters" do
    client = TestClient.new("http://127.0.0.1:9393", TestCaller.new)
    client.scheme.must_equal 'http'
    client.host.must_equal '127.0.0.1'
    client.port.must_equal 9393
  end

  it "#initialize provides a default port of 80 if not supplied in uri" do
    client = TestClient.new("http://127.0.0.1", TestCaller.new)
    client.port.must_equal 80
  end

  it "#initialize provides a default scheme of http if not provided in uri" do
    client = TestClient.new("//127.0.0.1", TestCaller.new)
    client.scheme.must_equal 'http'
  end

end

class TestClientWithOwnInitializer
  include SimpleApiClient

  attr_accessor :my_string

  def initialize string
    super('http://127.0.0.1:9393', TestCaller.new)
    self.my_string = string
  end

end

describe TestClientWithOwnInitializer do
  it '#initializes properly' do
    client = TestClientWithOwnInitializer.new('something')
    client.scheme.must_equal 'http'
    client.host.must_equal '127.0.0.1'
    client.port.must_equal 9393
    client.caller.class.must_equal TestCaller
    client.my_string.must_equal 'something'
  end

end
