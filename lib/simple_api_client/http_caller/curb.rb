require 'curb'

module HttpCaller
  class Curb

    def response http
      Response.new(http.response_code, http.body_str)
    end

    def call opts
      accept = HttpCaller::APPLICATION_TYPES[opts.fetch(:accept, :json)]
      content_type = HttpCaller::APPLICATION_TYPES[opts.fetch(:content_type, :json)]

      begin
        case opts[:method]
        when :post
          http = Curl.post(opts[:uri].to_s, opts[:payload]) do |http|
            http.headers['Content-Type'] = content_type
            http.headers['Accept'] = accept
          end
          response(http)
        when :get
          http = Curl.get(opts[:uri].to_s) do |http|
            http.headers['Accept'] = accept
          end
          response(http)
        when :put
          http = Curl.put(opts[:uri].to_s, opts[:payload]) do |http|
            http.headers['Content-Type'] = content_type
            http.headers['Accept'] = accept
          end
          response(http)
        else
          raise ArgumentError.new("Unknown call method: #{opts[:method]}")
        end
      rescue Curl::Err::ConnectionFailedError
        raise Errno::ECONNREFUSED
      rescue Curl::Err::TimeoutError
        raise Errno::ETIMEDOUT
      end
    end

  end
end
