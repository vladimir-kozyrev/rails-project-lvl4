# frozen_string_literal: true

module Web
  class AuthController < ApplicationController
    def callback
      @user = User.find_or_create_from_auth(auth_hash)
      if @user
        session[:user_id] = @user.id
        redirect_to root_path, notice: t('.success')
      else
        redirect_to root_path, alert: t('.failure')
      end
    end

    def sign_out
      reset_session
      redirect_to root_url, notice: t('.signed_out')
    end

    private

    def auth_hash
      request.env['omniauth.auth']
    end
  end
end
