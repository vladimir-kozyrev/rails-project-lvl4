# frozen_string_literal: true

require 'test_helper'

class RepositoryCheckJobTest < ActiveJob::TestCase
  test 'JavsScript repo check succeeds' do
    check = repository_checks(:one)
    RepositoryCheckJob.perform_now(check)
    check.reload
    assert { check.finished? }
    assert { check.passed? }
  end

  test 'Ruby repo check succeeds' do
    check = repository_checks(:two)
    RepositoryCheckJob.perform_now(check)
    check.reload
    assert { check.finished? }
    assert { check.passed? }
  end
end
