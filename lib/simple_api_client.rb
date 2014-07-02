require 'simple_api_client/version'
require 'simple_api_client/http_caller/curb'
require 'simple_api_client/http_caller/response'
require 'simple_api_client/http_caller/application_types'
require 'active_support/core_ext/module/delegation'
require 'json'


module SimpleApiClient

  ARGUMENT_ERROR_MESSAGE_HOST_MISSING = 'First argument must be a URI object or a URI string that provides a host. (i.e //myhost or http://myhost). Note: Scheme defaults to http if not provided.'
  ARGUMENT_ERROR_MESSAGE_RESPOND_TO_CALL_NEEDED = 'Second argument must be a class that response_to?(:call).'

  delegate :host, :port, to: :@uri
  delegate :call, to: :@caller
  attr_reader :caller

  def initialize uri, api_caller
    @uri = URI(uri)
    raise ArgumentError.new(ARGUMENT_ERROR_MESSAGE_HOST_MISSING) if @uri.host.nil?
    raise ArgumentError.new(ARGUMENT_ERROR_MESSAGE_RESPOND_TO_CALL_NEEDED) unless api_caller.respond_to?(:call)
    @caller = api_caller
  end

  def scheme
    @uri.scheme || 'http'
  end

  def uri relative_path
    URI("#{scheme}://#{host}:#{port}#{relative_path}")
  end

end
