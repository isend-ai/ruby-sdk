require 'httparty'
require 'json'

require_relative 'isend/client'
require_relative 'isend/version'

module ISend
  class Error < StandardError; end
  class InvalidArgumentError < Error; end
  class ApiError < Error; end
end 