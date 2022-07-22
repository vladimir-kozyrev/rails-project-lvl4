# frozen_string_literal: true

require 'test_helper'

class CreateRepositoryHookJobTest < ActiveJob::TestCase
  test 'repository hook is created' do
    repository = repositories(:one)
    repo_full_name = repository.full_name
    github_token = repository.user.token
    CreateRepositoryHookJob.perform_now(repo_full_name, github_token)
    expected_response = JSON.parse(load_fixture('octokit_create_hook_response.json'))
    assert { Octokiter.create_hook(repo_full_name, github_token) == expected_response }
  end
end
