# SimpleApiClient

A module to help create api clients quickly. The idea is you shou ld only have to define your endpoints and not worry about setup and the http client.

## Installation

Add this line to your application's Gemfile:

    gem 'simple_api_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_api_client

## Usage



```ruby
require 'simple_api_client'

class YourClientClass

  include SimpleApiClient

  #including SimpleApiClient gives you a base initialize method that accepts two parameters.
  #param1: excepts a URI object (which is used to set the Scheme, Host, Port etc, of your api.
  #param2: is an object that responses to a call method which needs to accept a hash of options.

  #Define your own endpoints

  def client_info(client_id, payload)
    call(method: :get, uri: uri('/client_info')
  end


end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/simple_api_client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
