# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# OmniAuth will not make actual requests to external sites during the tests
OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def load_fixture(filename)
    File.read(File.dirname(__FILE__) + "/fixtures/files/#{filename}")
  end
end

class ActionDispatch::IntegrationTest
  def sign_in(user)
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: user.email,
        image: user.image_url,
        name: user.name,
        nickname: user.nickname
      },
      credentials: {
        token: user.token
      }
    }
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)
    get callback_auth_url('github')
  end

  def sign_out
    delete sign_out_url
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
