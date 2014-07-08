require 'net/http'

module HttpCaller
  class NetHttp

      # ==== Exceptions
      # ::Errno::ECONNREFUSED:: - if the server is unresponsive
      # ::Errno::ECONNRESET:: - the remote host reset the connection request
      # ::Errno::ETIMEDOUT:: - timed out
      def call opts
        accept = HttpCaller::APPLICATION_TYPES[opts.fetch(:accept, :json)]
        content_type = HttpCaller::APPLICATION_TYPES[opts.fetch(:content_type, :json)]

        http = Net::HTTP.new(opts[:uri].host, opts[:uri].port)
        case opts[:method]
        when :post
          request = Net::HTTP::Post.new(opts[:uri].request_uri)
          request.body = opts[:payload]
          request['Content-Type'] = content_type
        when :get
          request = Net::HTTP::Get.new(opts[:uri].request_uri)
        when :put
          request = Net::HTTP::Put.new(opts[:uri].request_uri)
          request.body = opts[:payload]
          request['Content-type'] = content_type
        else
          raise ArgumentError.new("Unknown call method: #{opts[:method]}")
        end
        request['Accept'] = accept
        response = http.request(request)
        Response.new(response.code.to_i, response.body)
      end

  end
end
