class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  around_action :switch_locale
  helper_method :current_user
  helper_method :current_user_id
  helper_method :current_user_mining_started?

  private

  def authorize_user
    user_id = params[:user_id]
    if user_id.present?
      session[:user_id] = user_id.to_i
    end
  end

  def current_user
    Current.user ||= (User.find_by(telegram_id: session[:user_id]) || User.first)
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

  def switch_locale(&action)
    @locale = params[:locale] || I18n.default_locale
    I18n.with_locale(@locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
