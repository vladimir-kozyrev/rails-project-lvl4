# frozen_string_literal: true

module Web
  class Repositories::ChecksController < ApplicationController
    before_action :verify_signed_in, only: %i[create show]
    after_action :verify_authorized, only: %i[create show]

    def create
      repository = Repository.find(params[:repository_id])
      authorize repository, :show?
      check = repository.checks.build
      if check.save
        RepositoryCheckJob.perform_later(check)
        redirect_to repository, notice: t('.success')
      else
        redirect_to repository, notice: t('.failure')
      end
    end

    def show
      @check = Repository::Check.find(params[:id])
      authorize @check.repository, :show?
      @check_output_json = JSON.parse(@check.output || '[]')
    end
  end
end
