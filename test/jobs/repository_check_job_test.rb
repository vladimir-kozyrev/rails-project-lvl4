# frozen_string_literal: true

require 'test_helper'

class RepositoryCheckJobTest < ActiveJob::TestCase
  test 'check fails if linter returns non-zero exit code' do
    check = repository_checks(:one)
    RepositoryCheckJob.perform_now(check)
    check.reload
    assert { check.failed? }
    assert { check.output == load_fixture('eslint_check_result.json') }
  end
end
