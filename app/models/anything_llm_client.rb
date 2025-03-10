# app/services/anything_llm_client.rb
require 'httparty'

class AnythingLlmClient
  include HTTParty
  base_uri Rails.application.credentials.dig(:anything_llm, :base_url) || 'http://localhost:3001'

  headers 'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{Rails.application.credentials.dig(:anything_llm, :api_key)}"

  class << self
    def workspace
      Rails.application.credentials.dig(:anything_llm, :workspace) || 'testing'
    end

    def create_thread
      response = post("/api/v1/workspace/#{workspace}/thread/new", body: {}.to_json)
      handle_response(response)[:thread][:slug] || raise("Failed to create thread: No slug returned")
    end

    def send_query(query, thread_slug)
      response = post("/api/v1/workspace/#{workspace}/thread/#{thread_slug}/chat",
                     body: { message: query, mode: 'chat' }.to_json)
      handle_response(response)
    end

    # Define get as a class method using HTTParty's built-in functionality
    def get(path, options = {})
      super(path, options.merge(headers: headers))
    end

    private

    def handle_response(response)
      case response.code
      when 200..299
        JSON.parse(response.body, symbolize_names: true)
      when 400
        raise "Bad request: #{response.body}"
      when 401
        raise "Unauthorized: Check your API key in Rails credentials"
      when 404
        raise "Not found: #{response.body}"
      else
        raise "Error: #{response.code} - #{response.body}"
      end
    end
  end
end
