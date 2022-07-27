# frozen_string_literal: true

module AuthConcern
  extend ActiveSupport::Concern

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def signed_in?
    current_user.present?
  end

  def verify_signed_in
    return if signed_in?

    flash[:alert] = t('web.auth.not_signed_in')
    redirect_back(fallback_location: root_path)
  end
end
