module Api
  class ChatsController < ApplicationController
    def index
      @chats = Chat.where('created_at > ?', 60.minutes.ago).order(created_at: :desc)
      render 'index', status: :ok
    end

    def create
      @chat = Chat.new(chat_params)
      
      begin
        if @chat.save
          render 'show', status: :ok
        else
          Rails.logger.error("Chat save failed: #{@chat.errors.full_messages}")
          render json: { errors: @chat.errors.full_messages }, status: :bad_request
        end
      rescue => e
        Rails.logger.error("Exception in chat creation: #{e.message}")
        render json: { error: "Server error: #{e.message}" }, status: :internal_server_error
      end
    end

    private

    def chat_params
      params.require(:chat).permit(:message, :name)
    end
  end
end
