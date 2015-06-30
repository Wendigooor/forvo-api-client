require 'forvo_api_client/version'
require 'forvo_api_client/client'
require 'net/http'
require 'json'
require 'ostruct'

module ForvoApiClient
  API_DOMAIN = 'apicommercial.forvo.com'.freeze
  LIMIT_REACHED = 'Limit/day reached.'.freeze
  INCORRECT_DOMAIN = 'Calling from incorrect domain.'.freeze
  INVALID_VALUE = 'Invalid value'.freeze

  Error = Class.new(StandardError)
  LimitReachedError = Class.new(Error)
  IncorrectDomainError = Class.new(Error)
  InvalidValueError = Class.new(Error)
end
