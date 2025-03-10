# app/controllers/chat_controller.rb
class ChatController < ApplicationController
  allow_unauthenticated_access only: [:message]
  before_action :resume_session, only: [:message]

  def message
    begin
      # Ensure thread_slug is valid; create new if invalid or missing
      thread_slug = session[:thread_slug]
      unless thread_slug && thread_exists?(thread_slug)
        Rails.logger.debug "Creating new thread; old slug invalid: #{thread_slug}"
        session[:thread_slug] = thread_slug = AnythingLlmClient.create_thread
      end

      Rails.logger.debug "Using thread slug: #{thread_slug}"
      response = AnythingLlmClient.send_query(params[:message], thread_slug)
      Rails.logger.debug "AnythingLLM response: #{response.inspect}"
      response_text = response[:textResponse] || response[:text] || response.to_s
      render json: { response: response_text }
    rescue StandardError => e
      Rails.logger.error "Error in ChatController#message: #{e.message}"
      # Handle invalid thread or workspace by creating a new thread
      if e.message.include?("not valid") || e.message.include?("Not found")
        Rails.logger.debug "Retrying with new thread due to: #{e.message}"
        session[:thread_slug] = thread_slug = AnythingLlmClient.create_thread
        retry
      end
      render json: { response: "Sorry, something went wrong: #{e.message}" }, status: :internal_server_error
    end
  end

  private

  def thread_exists?(thread_slug)
    response = AnythingLlmClient.get("/api/v1/workspace/#{AnythingLlmClient.workspace}/thread/#{thread_slug}/chats")
    response.code == 200
  rescue
    false # Thread doesn’t exist or request failed
  end
end
