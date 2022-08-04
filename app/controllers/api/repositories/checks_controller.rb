# frozen_string_literal: true

module Api
  class Repositories::ChecksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      if params[:repository].blank?
        head :unprocessable_entity
        return
      end

      repo_full_name = params[:repository][:full_name]
      repository = Repository.find_by(full_name: repo_full_name)

      if repository.blank?
        head :unprocessable_entity
        return
      end

      check = repository.checks.build
      if check.save
        RepositoryCheckJob.perform_later(check)
        head :ok
      else
        head :unprocessable_entity
      end
    end
  end
end
