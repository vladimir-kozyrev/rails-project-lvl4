# frozen_string_literal: true

require 'test_helper'

class UpdateRepositoryMetadataJobTest < ActiveJob::TestCase
  test 'repository metadata is updated' do
    repository = repositories(:one)
    UpdateRepositoryMetadataJob.perform_now(repository.github_id)
    repository.reload
    assert { repository.name == 'Hello-World' }
    assert { repository.owner_name == 'octocat' }
  end
end
