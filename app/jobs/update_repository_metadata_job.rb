# frozen_string_literal: true

class UpdateRepositoryMetadataJob < ApplicationJob
  queue_as :default

  def perform(repo_id)
    repository = Repository.find_by(github_id: repo_id)
    github_token = repository.user.token
    repo_metadata = new_repo_params(Octokiter.repo(repo_id, github_token))
    metadata_updated = repository.update(repo_metadata)
    if metadata_updated
      repository.reload
      CreateRepositoryHookJob.perform_later(repository.full_name, github_token)
    else
      Rails.logger.error("Failed to update repository with id #{repo_id}")
    end
  end

  private

  def new_repo_params(repo_metadata)
    language = (repo_metadata['parent'] ? repo_metadata['parent']['language'] : repo_metadata['language']).downcase
    {
      link: repo_metadata['html_url'],
      owner_name: repo_metadata['owner']['login'],
      name: repo_metadata['name'],
      full_name: repo_metadata['full_name'],
      description: repo_metadata['description'],
      default_branch: repo_metadata['default_branch'],
      watchers_count: repo_metadata['watchers_count'],
      language: language,
      repo_created_at: repo_metadata['created_at'],
      repo_updated_at: repo_metadata['updated_at']
    }
  end
end
