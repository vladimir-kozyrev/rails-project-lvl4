# frozen_string_literal: true

require 'test_helper'

class UpdateRepositoryMetadataJobTest < ActiveJob::TestCase
  test 'repository metadata is updated' do
    repository = repositories(:one)
    UpdateRepositoryMetadataJob.perform_now(repository.github_id)
    repository.reload
    repository_dummy = JSON.parse(load_fixture('octokit_repo_response.json'))
    assert { repository.name == repository_dummy['name'] }
    assert { repository.owner_name == repository_dummy['owner']['login'] }
  end
end
