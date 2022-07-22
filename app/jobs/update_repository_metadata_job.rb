# frozen_string_literal: true

class UpdateRepositoryMetadataJob < ApplicationJob
  queue_as :default

  def perform(repo_id, github_token)
    repository = Repository.find_by(github_id: repo_id)
    repo_metadata = new_repo_params(repo_id, Octokiter.repo(repo_id, github_token))
    repository.update(repo_metadata)
  end

  private

  def new_repo_params(repo_id, repo_metadata)
    language = (repo_metadata['parent'] ? repo_metadata['parent']['language'] : repo_metadata['language']).downcase
    {
      github_id: repo_id,
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
