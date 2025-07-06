require 'spec_helper'

RSpec.describe ISend::Client do
  let(:api_key) { 'test-api-key' }
  let(:client) { described_class.new(api_key) }
  let(:base_url) { 'https://www.isend.ai/api' }

  describe '#initialize' do
    it 'creates a client with valid API key' do
      expect(client.api_key).to eq(api_key)
      expect(client.timeout).to eq(30)
    end

    it 'raises error for empty API key' do
      expect { described_class.new('') }.to raise_error(ISend::InvalidArgumentError, 'API key is required')
      expect { described_class.new(nil) }.to raise_error(ISend::InvalidArgumentError, 'API key is required')
    end

    it 'accepts custom timeout' do
      client_with_timeout = described_class.new(api_key, timeout: 60)
      expect(client_with_timeout.timeout).to eq(60)
    end

    it 'strips whitespace from API key' do
      client_with_whitespace = described_class.new(" #{api_key} ")
      expect(client_with_whitespace.api_key).to eq(api_key)
    end
  end

  describe '#send_email' do
    let(:email_data) do
      {
        template_id: 124,
        to: 'test@example.com',
        dataMapping: { name: 'Test User' }
      }
    end

    let(:success_response) do
      { 'status' => 'success', 'message_id' => '12345' }
    end

    before do
      stub_request(:post, "#{base_url}/send-email")
        .with(
          body: email_data.to_json,
          headers: {
            'Authorization' => "Bearer #{api_key}",
            'Content-Type' => 'application/json',
            'User-Agent' => "isend-ai-ruby-sdk/#{ISend::VERSION}"
          }
        )
        .to_return(status: 200, body: success_response.to_json)
    end

    it 'sends email successfully' do
      response = client.send_email(email_data)
      expect(response).to eq(success_response)
    end

    it 'raises error for invalid email data' do
      expect { client.send_email('invalid') }.to raise_error(ISend::InvalidArgumentError, 'Email data must be a hash')
      expect { client.send_email({}) }.to raise_error(ISend::InvalidArgumentError, 'template_id is required')
      expect { client.send_email(template_id: 124) }.to raise_error(ISend::InvalidArgumentError, 'to email address is required')
    end

    it 'raises error for API errors' do
      stub_request(:post, "#{base_url}/send-email")
        .to_return(status: 400, body: 'Bad Request')

      expect { client.send_email(email_data) }.to raise_error(ISend::ApiError, /HTTP error 400/)
    end

    it 'raises error for invalid JSON response' do
      stub_request(:post, "#{base_url}/send-email")
        .to_return(status: 200, body: 'invalid json')

      expect { client.send_email(email_data) }.to raise_error(ISend::ApiError, /Invalid JSON response/)
    end
  end
end 