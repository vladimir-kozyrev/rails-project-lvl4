# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :repository_checker, -> { RepositoryCheckerStub }
    register :octokit_client, -> { OctokitClientStub }
  else
    register :repository_checker, -> { RepositoryChecker }
    register :octokit_client, -> { OctokitClient }
  end
end
