module ForvoApi
  class Client
    API_URL = 'http://apifree.forvo.com/'.freeze
    LIMIT_REACHED = 'Limit/day reached.'.freeze
    INCORRECT_DOMAIN = 'Calling from incorrect domain.'.freeze
    INVALID_VALUE = 'Invalid value'.freeze

    LimitReachedError = Class.new(StandardError)
    IncorrectDomainError = Class.new(StandardError)
    InvalidValueError = Class.new(StandardError)

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

    # Options:
    #   - language
    #   - username
    #   - sex
    #     - m
    #     - f
    #   - rate
    #   - order
    #     - date-asc
    #     - date-desc
    #     - rate-asc
    #     - rate-desc
    #   - limit
    def send_request!(action, word, options = {})
      params = [
        :format, 'json',
        :action, action,
        :key, api_key,
        :word, word
      ].concat(options.to_a) * ?/

      response = Net::HTTP.get(URI.parse(URI.encode(API_URL + params)))
      data = JSON.parse(response)

      if data.is_a?(Array)
        raise LimitReachedError, LIMIT_REACHED if data.first == LIMIT_REACHED
        raise IncorrectDomainError, INCORRECT_DOMAIN if data.first == INCORRECT_DOMAIN
        raise InvalidValueError, data.first if data.first.start_with? INVALID_VALUE
      end

      data
    end
  end
end
