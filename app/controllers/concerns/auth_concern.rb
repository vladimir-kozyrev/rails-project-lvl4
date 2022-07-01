# frozen_string_literal: true

module AuthConcern
  extend ActiveSupport::Concern

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def signed_in?
    current_user.present?
  end
end
