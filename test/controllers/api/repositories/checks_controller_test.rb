# frozen_string_literal: true

require 'test_helper'

class Api::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'fail to create check with unknown repository' do
    webhook_params = load_fixture('unknown_repository_webhook_payload.json')
    post api_checks_url, params: JSON.parse(webhook_params)
    assert_response :unprocessable_entity
  end

  test 'should create check for existing repository' do
    webhook_params = JSON.parse(load_fixture('existing_repository_webhook_payload.json'))
    post api_checks_url, params: webhook_params
    assert_response :ok
    repository = Repository.find_by(full_name: webhook_params['repository']['full_name'])
    check = repository.checks.last
    assert { check.passed? }
    assert { check.finished? }
  end
end
