require 'httparty'
require 'json'

module ISend
  class Client
    include HTTParty
    
    API_BASE_URL = 'https://www.isend.ai/api'
    
    attr_reader :api_key, :timeout
    
    # Create a new ISend::Client instance
    #
    # @param api_key [String] Your isend.ai API key
    # @param config [Hash] Additional configuration options
    # @option config [Integer] :timeout (30) Request timeout in seconds
    # @raise [ISend::InvalidArgumentError] if API key is empty
    def initialize(api_key, config = {})
      if api_key.nil? || api_key.strip.empty?
        raise ISend::InvalidArgumentError, 'API key is required'
      end
      
      @api_key = api_key.strip
      @timeout = config[:timeout] || 30
      
      # Configure HTTParty
      self.class.base_uri API_BASE_URL
      self.class.default_timeout @timeout
      self.class.headers({
        'Authorization' => "Bearer #{@api_key}",
        'Content-Type' => 'application/json',
        'User-Agent' => "isend-ai-ruby-sdk/#{ISend::VERSION}"
      })
    end
    
    # Send an email using isend.ai
    #
    # @param email_data [Hash] Email data including template_id, to, dataMapping, etc.
    # @option email_data [Integer] :template_id The template ID to use
    # @option email_data [String] :to Recipient email address
    # @option email_data [Hash] :dataMapping Data mapping for template variables
    # @return [Hash] Response from the API
    # @raise [ISend::ApiError] if the API request fails
    def send_email(email_data)
      validate_email_data(email_data)
      
      response = self.class.post('/send-email', {
        body: email_data.to_json,
        headers: { 'Content-Type' => 'application/json' }
      })
      
      handle_response(response)
    end
    
    private
    
    def validate_email_data(email_data)
      unless email_data.is_a?(Hash)
        raise ISend::InvalidArgumentError, 'Email data must be a hash'
      end
      
      unless email_data[:template_id]
        raise ISend::InvalidArgumentError, 'template_id is required'
      end
      
      unless email_data[:to]
        raise ISend::InvalidArgumentError, 'to email address is required'
      end
    end
    
    def handle_response(response)
      case response.code
      when 200..299
        begin
          JSON.parse(response.body)
        rescue JSON::ParserError => e
          raise ISend::ApiError, "Invalid JSON response: #{e.message}"
        end
      else
        raise ISend::ApiError, "HTTP error #{response.code}: #{response.body}"
      end
    end
  end
end 