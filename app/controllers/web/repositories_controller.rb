# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :verify_signed_in
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
      @checks = @repository.checks.order(created_at: :desc)
    end

    def create
      repo_id = permitted_params[:github_id].to_i
      if Repository.find_by(github_id: repo_id)
        redirect_to repositories_path, notice: t('.success')
        return
      end

      @repository = current_user.repositories.build(github_id: repo_id)
      if @repository.save
        UpdateRepositoryMetadataJob.perform_later(repo_id)
        redirect_to repositories_path, notice: t('.success')
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def permitted_params
      params.require(:repository).permit(:github_id)
    end
  end
end
