# frozen_string_literal: true

module Web
  class Repositories::ChecksController < ApplicationController
    before_action :verify_signed_in, only: :create
    after_action :verify_authorized, only: %i[create show]

    def create
      @repository = Repository.find(params[:repository_id])
      authorize @repository, :show?
      @check = @repository.checks.build
      if @check.save
        RepositoryCheckJob.perform_later(@repository, @check)
        redirect_to @repository, notice: t('.success')
      else
        redirect_to @repository, notice: t('.failure')
      end
    end

    def show; end
  end
end
