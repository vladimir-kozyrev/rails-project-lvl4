# frozen_string_literal: true

module Api
  class Repositories::ChecksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      if params[:repository].blank?
        render status: :unprocessable_entity, json: '{"message": "The payload must include repository attribute"}'
        return
      end

      repo_full_name = params[:repository][:full_name]
      repository = Repository.find_by(github_id: repo_full_name)

      if repository.blank?
        render status: :unprocessable_entity, json: '{"message": "A repository with that name have not been created"}'
        return
      end

      check = repository.checks.build
      if check.save
        RepositoryCheckJob.perform_later(check)
        render status: :created, json: '{"message": "A check was successfully created"}'
      else
        render status: :unprocessable_entity, json: '{"message": "Failed to create a new check"}'
      end
    end
  end
end
