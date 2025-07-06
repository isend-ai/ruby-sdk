# isend.ai Ruby SDK

A simple Ruby SDK for sending emails through isend.ai using various email connectors like AWS SES, SendGrid, Mailgun, and more.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'isend'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install isend
```

## Quick Start

```ruby
require 'isend'

# Initialize the client
client = ISend::Client.new('your-api-key-here')

# Send email using template
email_data = {
  template_id: 124,
  to: 'hi@isend.ai',
  dataMapping: {
    name: 'ISend'
  }
}

response = client.send_email(email_data)
puts response
```

## Usage

### Send Email Using Template

```ruby
email_data = {
  template_id: 124,
  to: 'hi@isend.ai',
  dataMapping: {
    name: 'ISend'
  }
}

response = client.send_email(email_data)
```

### With Configuration Options

```ruby
client = ISend::Client.new('your-api-key-here', timeout: 60)

email_data = {
  template_id: 124,
  to: 'hi@isend.ai',
  dataMapping: {
    name: 'ISend',
    company: 'Your Company'
  }
}

response = client.send_email(email_data)
```

## API Reference

### ISend::Client

#### Constructor
```ruby
ISend::Client.new(api_key, config = {})
```

**Parameters:**
- `api_key` (String): Your isend.ai API key
- `config` (Hash): Additional configuration options
  - `timeout` (Integer): Request timeout in seconds (default: 30)

#### Methods

##### send_email(email_data)
Sends an email using the provided template and data.

**Parameters:**
- `email_data` (Hash): Email data including:
  - `template_id` (Integer): The template ID to use
  - `to` (String): Recipient email address
  - `dataMapping` (Hash): Data mapping for template variables

**Returns:**
- `Hash`: Response from the API

## Error Handling

The SDK raises custom exceptions for different error types:

```ruby
begin
  response = client.send_email({
    template_id: 124,
    to: 'hi@isend.ai',
    dataMapping: {
      name: 'ISend'
    }
  })
rescue ISend::InvalidArgumentError => e
  puts "Invalid argument: #{e.message}"
rescue ISend::ApiError => e
  puts "API error: #{e.message}"
rescue ISend::Error => e
  puts "General error: #{e.message}"
end
```

### Exception Types

- `ISend::InvalidArgumentError`: Raised when invalid arguments are provided
- `ISend::ApiError`: Raised when the API request fails
- `ISend::Error`: Base exception class for all SDK errors

## Rails Integration

### In Rails Application

Add to your Gemfile:

```ruby
gem 'isend'
```

Create an initializer (`config/initializers/isend.rb`):

```ruby
ISEND_CLIENT = ISend::Client.new(ENV['ISEND_API_KEY'])
```

Use in your controllers or models:

```ruby
class UserMailer
  def self.send_welcome_email(user)
    email_data = {
      template_id: 124,
      to: user.email,
      dataMapping: {
        name: user.name,
        company: user.company
      }
    }
    
    ISEND_CLIENT.send_email(email_data)
  end
end
```

### Background Job Example

```ruby
class EmailJob < ApplicationJob
  queue_as :default

  def perform(user_id, template_id)
    user = User.find(user_id)
    
    email_data = {
      template_id: template_id,
      to: user.email,
      dataMapping: {
        name: user.name
      }
    }
    
    ISEND_CLIENT.send_email(email_data)
  end
end
```

## Examples

See the `examples/` directory for complete usage examples.

## Requirements

- Ruby 2.0 or higher
- HTTParty gem for HTTP requests

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/isend-ai/ruby-sdk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).