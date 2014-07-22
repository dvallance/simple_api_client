require 'simple_api_client/version'
require 'simple_api_client/http_caller/constants'
require 'simple_api_client/http_caller/net_http'
require 'simple_api_client/http_caller/response'
require 'active_support/core_ext/module/delegation'

# This module provides some simple basic methods to help create an HTTP based
# API client with minimum effort.
#
# If you have an HTTP based API endpoint that accepts and delivers its payloads
# via JSON or XML this gem is designed to quickly create the calling client. It
# does this by providing an #initialize method that handles setting your HTTP
# servers HOST, PORT, and SCHEME. These are set with a URI object or a URI
# parse-able string. This allows you to declare any endpoints paths relative to
# the provided URI.
#
# The second part of the equation is the Http client that actually makes the
# call to the server. One is provided in this gem, +HttpCaller::NetHttp+, which
# is just a wrapper around rubys Net::HTTP client. If your looking for something
# more performant you can use the +http_caller-curb+ gem which provides a
# wrapper around Curb (Libcurl bindings for Ruby). The HttpCaller is simply a
# class that implements a +#call+ method that accepts an options hash.
#
# ==HttpCallers
#
# +HttpCaller::NetHttp+ (provided with this gem) and +HttpCaller::Curb+
# (requires the http_caller-curb gem) are both very simple wrappers around
# existing HTTP clients and they both understand the following options.
# * :method - [:get, :post, :put] allows the caller to determine the type of
# call to perform.
# * :uri - the *absolute* url address for the endpoint. There is a convienence
# method #uri which will turn a relative path into the absolute path based on
# the initial URI passed to the initializer.
# * :payload - a :post or :put can accept a payload.
# * :accept - tells the server what format the payload will be [:json (default)
# or :xml].
# * :content_type - if your server api can respond in :json or :xml you can tell
# it which you prefer (:json is the default).
#
# The HttpCallers I've provided both wrap exceptions in a common format.
# * Errno::ECONNREFUSED - if the server is unresponsive
# * Errno::ECONNRESET - the remote host reset the connection request
# * Errno::ETIMEDOUT - timed out
#
# You can of course roll your own HttpCaller and if thats the case you can
# change up the option names and respond to anything you want.
#
# ==Usage
# This simplest usage would be to include the *SimpleApiClient* module in your
# intended client and provide some basic endpoints.
#    require 'simple_api_client'
#
#    class MyApiClient
#      include SimpleApiClient
#
#      def get_address(user_id)
#        # note the use of the #uri method to create an absolute uri
#        path = uri("/users/#{user_id}/address")
#
#        # call is delegated to the provided HttpCaller object.
#        call(uri: path, method: :get)
#      end
#
#      # a post example could look like this
#      def post_address(user_id, payload)
#        path = uri("/users/#{user_id}/address")
#        call(uri: path, method: :post, payload: payload)
#      end
#    end
#
#    my_client = MyApiClient.new('https://myserver:7788', HttpCaller::NetHttp.new)
#
#    #result is an HttpCaller::Response object which has a response code and body.
#    result = my_client.get_address(1)
#
#    puts result.code
#    # => 200
#
#    puts result.body #server specific, but the request will ask for json by default.
#    # =>  "{\"street address\":\"897 someroad\"}"
#
# The code behind the scenes is vary simple and there is just an un-enforced
# contract between the client class and the provided HttpCaller class. Your
# defined endpoints simply pass the options to the HttpCaller and expect it to
# respond. In my provided code that response is an HttpCaller::Response object
# but this can be anything you want if you provide your own.
#
# @author David Vallance
module SimpleApiClient

  ARGUMENT_ERROR_MESSAGE_HOST_MISSING = 'First argument must be a URI object or a URI string that provides a host. (i.e //myhost or http://myhost). Note: Scheme defaults to http if not provided.'
  ARGUMENT_ERROR_MESSAGE_RESPOND_TO_CALL_NEEDED = 'Second argument must be a class that response_to?(:call).'

  delegate :host, :port, to: :@uri
  delegate :call, to: :@caller
  attr_reader :caller

  # Provides an default initializer for your class along with validation
  # checking on the accepted params. An ArgumentError will be raised if the
  # parameters do not satisfy expectations.
  #
  # @param uri [URI::HTTP, String] a URI object or a URI parse-able string.
  # @param api_caller [#call] an object that responds to a #call method.
  # HttpCaller::NetHttp is provided with this simple_api_client gem. See gem
  # [http_caller-curb] for an optional HttpCaller::Curb implimentation using
  # curb.
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
