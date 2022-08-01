# frozen_string_literal: true

require 'fileutils'
require 'securerandom'

class RepositoryCheck
  def self.download(repository)
    repo_clone_path = "/tmp/#{SecureRandom.uuid}"
    command = "git clone #{repository.link} #{repo_clone_path}"
    stderr, exit_status = Open3.popen3(command) do |_stdin, _stdout, stderr, wait_thr|
      [stderr.read, wait_thr.value]
    end
    if exit_status.exitstatus != 0 && stderr.present?
      Rails.logger.error "Failed to clone repository #{repository.link} to #{repo_clone_path}"
      Rails.logger.error "stderr: #{stderr}"
      FileUtils.rm_rf(repo_clone_path) and return nil
    end
    repo_clone_path
  end

  def self.check(repository_path, check)
    language = check.repository.language
    linter = "#{language.capitalize}Linter".constantize
    stdout, exit_status = linter.lint(repository_path)
    stdout_json = JSON.parse(stdout.presence || '[]')
    check.output = linter.format_output(stdout_json).to_json
    check.offense_count = linter.offense_count(stdout_json)
    check.commit_hash = commit_hash(repository_path)
    exit_status
  ensure
    FileUtils.rm_rf(repository_path)
  end

  def self.commit_hash(repo_clone_path)
    command = "cd #{repo_clone_path} && git rev-parse --short HEAD"
    commit_hash, exit_status = Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
      [stdout.read, wait_thr.value]
    end
    Rails.logger.error "Failed to get commit hash from #{repo_clone_path}" if exit_status.exitstatus != 0
    commit_hash
  end
end
