# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :verify_signed_in, only: %i[index new show create]
    after_action :verify_authorized, only: :show

    def index
      @repositories = current_user.repositories
    end

    def new
      @repository = Repository.new
    end

    def show
      @repository = Repository.find(params[:id])
      authorize @repository
    end

    def create
      repo_id = permitted_params[:github_id].to_i
      redirect_to repositories_path, notice: t('.success') and return if Repository.find_by(github_id: repo_id)

      repo_metadata = Octokiter.repo(repo_id, current_user.token)
      @repository = current_user.repositories.build(new_repo_params(repo_metadata))
      if @repository.save
        create_webhook(@repository.full_name)
        redirect_to @repository, notice: t('.success')
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def permitted_params
      params.require(:repository).permit(:github_id)
    end

    def new_repo_params(repo_metadata)
      language = (repo_metadata['parent'] ? repo_metadata['parent']['language'] : repo_metadata['language']).downcase
      {
        github_id: repo_metadata['id'],
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

    def create_webhook(repo_full_name)
      github_token = current_user.token
      hooks_with_equal_config = Octokiter.hooks(repo_full_name, github_token).select do |hook|
        hook['config'].to_h == Octokiter.webhook_config
      end
      Octokiter.create_hook(repo_full_name, github_token) if hooks_with_equal_config.empty?
    end
  end
end
