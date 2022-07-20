# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

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

  setup do
    stubbed_get_repos_response = load_fixture('octokit_repo_response.json')
    stub_request(:get, 'https://api.github.com/user/repos?per_page=100')
      .to_return(status: 200, body: "[#{stubbed_get_repos_response}]", headers: { 'Content-Type': 'application/json' })

    get_repo_template = Addressable::Template.new('https://api.github.com/repositories/{id}')
    stubbed_get_repo_response = load_fixture('octokit_repo_response.json')
    stub_request(:get, get_repo_template)
      .to_return(status: 200, body: stubbed_get_repo_response, headers: { 'Content-Type': 'application/json' })

    get_hook_template = Addressable::Template.new('https://api.github.com/repos/{owner_name}/{repo_name}/hooks?per_page=100')
    stubbed_get_hooks_respone = load_fixture('octokit_get_hooks_response.json')
    stub_request(:get, get_hook_template)
      .to_return(status: 200, body: stubbed_get_hooks_respone, headers: { 'Content-Type': 'application/json' })

    create_hook_template = Addressable::Template.new('https://api.github.com/repos/{owner_name}/{repo_name}/hooks')
    stubbed_create_hook_response = load_fixture('octokit_create_hook_response.json')
    stub_request(:post, create_hook_template)
      .to_return(status: 200, body: stubbed_create_hook_response, headers: { 'Content-Type': 'application/json' })
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
