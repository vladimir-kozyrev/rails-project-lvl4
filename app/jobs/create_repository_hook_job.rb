# frozen_string_literal: true

class CreateRepositoryHookJob < ApplicationJob
  queue_as :default

  def perform(repo_full_name, github_token)
    hooks_with_equal_config = Octokiter.hooks(repo_full_name, github_token).select do |hook|
      hook['config'].to_h == Octokiter.webhook_config
    end
    Octokiter.create_hook(repo_full_name, github_token) if hooks_with_equal_config.empty?
  rescue StandardError
    Rails.logger.error("Failed to create webhook for repository #{repo_full_name}")
    raise
  end
end
