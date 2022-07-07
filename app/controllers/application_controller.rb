# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthConcern

  # rubocop:disable Style/GuardClause
  def verify_signed_in
    unless signed_in?
      flash[:alert] = t('web.auth.not_signed_in')
      redirect_back(fallback_location: root_path)
    end
  end
  # rubocop:enable Style/GuardClause
end
