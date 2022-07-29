# frozen_string_literal: true

require_relative 'octokit_client'

class OctokitClientStub
  def self.repo(_repo_id, _github_token)
    JSON.parse(File.read('test/fixtures/files/octokit_repo_response.json'))
  end

  def self.repos(_github_token)
    JSON.parse(File.read('test/fixtures/files/octokit_repos_response.json'))
  end

  def self.hooks(_repo_full_name, _github_token)
    JSON.parse(File.read('test/fixtures/files/octokit_get_hooks_response.json'))
  end

  def self.create_hook(_repo_full_name, _url, _github_token)
    JSON.parse(File.read('test/fixtures/files/octokit_create_hook_response.json'))
  end

  def self.webhook_config(url)
    OctokitClient.webhook_config(url)
  end
end
