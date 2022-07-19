# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  def setup
    sign_in(users(:joe))
  end

  test 'should get show' do
    check = repository_checks(:one)
    get repository_check_url(check.repository, check)
    assert_response :success
  end

  test 'should create check' do
    repository = repositories(:one)
    post repository_checks_url(repository.id)
    assert_response :redirect, message: 'A check was successfully created'
    assert_enqueued_with job: RepositoryCheckJob
  end
end
