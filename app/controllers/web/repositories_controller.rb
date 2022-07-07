# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :verify_signed_in, only: %i[new show create]

    def index
      @repositories = Repository.all
    end

    def new
      @repository = Repository.new
    end

    def show
      @repository = Repository.find(params[:id])
    end

    def create
      repo_full_name = permitted_params[:link].delete_prefix('https://github.com/')
      repo_metadata = current_user.octokit_client.repo(repo_full_name)
      @repository = Repository.new(new_repo_params(repo_metadata))
      if @repository.save
        redirect_to @repository, notice: t('.success')
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def permitted_params
      params.require(:repository).permit(:link)
    end

    def new_repo_params(repo_metadata)
      {
        link: repo_metadata['html_url'],
        owner_name: repo_metadata['owner']['login'],
        repo_name: repo_metadata['name'],
        description: repo_metadata['description'],
        default_branch: repo_metadata['default_branch'],
        watchers_count: repo_metadata['watchers_count'],
        language: repo_metadata['language'],
        repo_created_at: repo_metadata['created_at'],
        repo_updated_at: repo_metadata['updated_at']
      }
    end
  end
end
