# ForvoApiClient

[![Code Climate](https://codeclimate.com/github/FoboCasteR/forvo-api-client.png)](https://codeclimate.com/github/FoboCasteR/forvo-api-client)

[Forvo API](http://api.forvo.com/) client

## Installation

Add this line to your application's Gemfile:

    gem 'forvo_api_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install forvo_api_client

## Usage

```ruby
forvo_api = ForvoApiClient::Client.new(API_KEY)
forvo_api.word_pronunciations('word', options)
# Wrap response items into objects:
forvo_api.word_pronunciations('word', options.merge(:wrap_into_objects => true))
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
