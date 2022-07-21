# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :repository_check, -> { RepositoryCheckStub }
    register :octokit_client, -> { OctokitClientStub }
  else
    register :repository_check, -> { RepositoryCheck }
    register :octokit_client, -> { OctokitClient }
  end
end
