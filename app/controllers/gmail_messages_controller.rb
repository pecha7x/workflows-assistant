class GmailMessagesController < ApplicationController
  def index
    @messages = current_user.gmail_messages.page(params[:page]).per(10).ordered
  end

  def show
    @message = current_user.gmail_messages.find(params[:id])
  end
end
