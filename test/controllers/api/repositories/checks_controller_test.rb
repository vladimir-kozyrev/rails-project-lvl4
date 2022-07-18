# frozen_string_literal: true

require 'test_helper'

class Api::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'fail to create check with unknown repository' do
    json_params = load_fixture('unknown_repository_webhook_payload.json')
    post api_checks_url, params: JSON.parse(json_params)
    assert_response :unprocessable_entity
  end

  test 'should create check for existing repository' do
    json_params = load_fixture('existing_repository_webhook_payload.json')
    post api_checks_url, params: JSON.parse(json_params)
    assert_response :created
  end
end
