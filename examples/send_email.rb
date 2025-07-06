#!/usr/bin/env ruby

require_relative '../lib/isend'

# Initialize the client with your API key
client = ISend::Client.new('your-api-key-here')

# Example: Send email using template
begin
  email_data = {
    template_id: 124,
    to: 'hi@isend.ai',
    dataMapping: {
      name: 'ISend'
    }
  }
  
  response = client.send_email(email_data)
  
  puts "Email sent successfully!"
  puts response
rescue ISend::InvalidArgumentError => e
  puts "Invalid argument: #{e.message}"
rescue ISend::ApiError => e
  puts "API error: #{e.message}"
rescue ISend::Error => e
  puts "General error: #{e.message}"
end 