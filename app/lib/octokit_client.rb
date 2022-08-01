# frozen_string_literal: true

class OctokitClient
  def self.repo(repo_id, github_token)
    @github_token = github_token
    client.repo(repo_id)
  end

  def self.repos(github_token)
    @github_token = github_token
    client.repos
  end

  def self.hooks(repo_full_name, github_token)
    @github_token = github_token
    client.hooks(repo_full_name)
  end

  def self.create_hook(repo_full_name, github_token)
    @github_token = github_token
    client.create_hook(repo_full_name, 'web', webhook_config)
  end

  def self.webhook_config
    {
      url: Rails.application.routes.url_helpers.api_checks_url, content_type: 'json', insecure_ssl: '0'
    }
  end

  def self.client
    @client ||= Octokit::Client.new(access_token: @github_token, auto_paginate: true)
  end
end
