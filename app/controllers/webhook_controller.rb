class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[ telegram  ]

  helper_method :current_user
  helper_method :current_user_id
  helper_method :current_user_mining_started?
  before_action :authorize_user, only: :home

  def home
  end

  def start_mining
    if user_logged_in?
      current_user.update mining_started: Time.zone.now
      redirect_to root_path
    end
  end

  def missions
  end

  def friends
  end

  def wallet
  end

  def more
  end

  def boost
  end

  def awaiting_payment
  end

  def claim
  end

  def contact_support
  end

  def add_content_and_earn
    @rewards = [
      { from: "100", to: "999", delta: "10K" },
      { from: "1K", to: "4.9K", delta: "25K" },
      { from: "5K", to: "9.9K", delta: "50K" },
      { from: "10K", to: "49.9K", delta: "100K" },
      { from: "50K", to: "99.9K", delta: "500K" },
      { from: "100K", to: "499.9K", delta: "1M" },
      { from: "500K", to: "999.9K", delta: "5K" },
      { from: "1M", to: nil, delta: "10M" }
    ]
  end

  def legal_information
  end

  def friends_list
  end

  def withdraw
  end

  def friends_learn_more
  end

  def push_mining_amount
    if user_logged_in? && current_user_mining_started?
      current_user.update mining: mining_amount_params
    end
  end

  def get_mining_amount
    render json: { amount: (user_logged_in? ? current_user.mining : 0.0) }
  end

  def claim_create
    flash.now[:alert] = "Claim amount too small"
    render turbo_stream: turbo_stream.update(
      "toast-frame",
      partial: "webhook/toast",
      locals: { message: flash[:alert], type: :alert }
    )
  end

  def terms_and_conditions
  end

  def contest_create
    contest = Contest.new contest_params

    if contest.save
      flash.now[:notice] = "Your link Sent Successfully"
      render turbo_stream: turbo_stream.update(
        "toast-frame",
        partial: "webhook/toast",
        locals: { message: flash[:notice], type: :success }
      )
    else
      flash.now[:alert] = "Error happened while link sended"
      render turbo_stream: turbo_stream.update(
        "toast-frame",
        partial: "webhook/toast",
        locals: { message: flash[:alert], type: :alert }
      )
    end
  end

  def telegram
    # Parse the incoming request
    data = params.to_unsafe_h

    # Process the incoming message
    if data["message"]
      chat_id = data["message"]["chat"]["id"]
      text = data["message"]["text"]

      # Respond to the user
      bot = Telegram::Bot::Client.new(Rails.application.credentials.telegram[:bot_token])
      bot.api.send_message(chat_id: chat_id, text: "You said: #{text}")
    end

    render json: { status: "ok" }, status: :ok
  end

  private

  def mining_amount_params
    params.require(:amount)
  end

  def contest_params
    params.require(:contest).permit(:url).merge(user_id: current_user.id)
  end

  def authorize_user
    user_id = params[:user_id]
    if user_id.present?
      session[:user_id] = user_id.to_i
    end
  end

  def current_user
    User.find_by(telegram_id: session[:user_id]) || User.first
  end

  def current_user_mining_started?
    current_user&.mining_started.present?
  end

  def user_logged_in?
    current_user.present?
  end

  def current_user_id
    current_user.telegram_id if user_logged_in?
  end
end
