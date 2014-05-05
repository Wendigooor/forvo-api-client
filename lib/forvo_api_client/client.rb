require 'cgi'

module ForvoApiClient
  class Client
    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    def word_pronunciations(word, options = {})
      wrap_into_objects = options.delete(:wrap_into_objects) || false

      response = send_request!('word-pronunciations', word, options)

      if wrap_into_objects
        response['items'].map { |item| OpenStruct.new(item) }
      else
        response['items']
      end
    end

    private

    def fetch!(path, limit = 10)
      raise ArgumentError, 'too many HTTP redirects' if limit == 0

      response = Net::HTTP.get_response(API_DOMAIN, path)

      case response
      when Net::HTTPSuccess then response.body
      when Net::HTTPRedirection then fetch!(response['location'], limit - 1)
      else
        response.error!
      end
    end

    def send_request!(action, word, options = {})
      response = fetch!(options_to_path(action, options.merge(word: CGI.escape(word))))
      data = JSON.parse(response)

      if data.is_a?(Array)
        error_message = data.first
        raise LimitReachedError, LIMIT_REACHED if error_message == LIMIT_REACHED
        raise IncorrectDomainError, INCORRECT_DOMAIN if error_message == INCORRECT_DOMAIN
        raise InvalidValueError, error_message if error_message.start_with? INVALID_VALUE
      end

      data
    end

    def options_to_path(action, options)
      [
        :format, 'json',
        :action, action,
        :key, api_key,
      ].concat(options.to_a).join('/').prepend('/')
    end
  end
end
