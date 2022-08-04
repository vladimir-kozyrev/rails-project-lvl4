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
    repository = repositories(:js)
    post repository_checks_url(repository.id)
    assert_redirected_to repository_url(repository)
    assert_performed_with job: RepositoryCheckJob
    check = repository.checks.last
    assert { check.finished? }
    assert { check.passed? }
  end
end
