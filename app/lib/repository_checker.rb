# frozen_string_literal: true

require 'fileutils'
require 'securerandom'

class RepositoryChecker
  def self.check(check)
    repository_path = download(check.repository)
    return false unless repository_path

    language = check.repository.language
    linter = "#{language.capitalize}Linter".constantize
    stdout, exit_status = linter.lint(repository_path)
    stdout_json = JSON.parse(stdout.presence || '[]')
    check.offense_count = linter.offense_count(stdout_json)
    check.output = linter.format_output(stdout_json).to_json
    check.commit_hash = commit_hash(repository_path)
    exit_status.zero?
  ensure
    FileUtils.rm_rf(repository_path)
  end

  class << self
    private

    def download(repository)
      repo_clone_path = "/tmp/#{SecureRandom.uuid}"
      command = "git clone #{repository.link} #{repo_clone_path}"
      stderr, exit_status = Open3.popen3(command) do |_stdin, _stdout, stderr, wait_thr|
        [stderr.read, wait_thr.value]
      end
      if exit_status.exitstatus != 0 && stderr.present?
        Rails.logger.error "Failed to clone repository #{repository.link} to #{repo_clone_path}"
        Rails.logger.error "stderr: #{stderr}"
        return nil
      end
      repo_clone_path
    end

    def commit_hash(repo_clone_path)
      command = "cd #{repo_clone_path} && git rev-parse --short HEAD"
      commit_hash, exit_status = Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
        [stdout.read, wait_thr.value]
      end
      Rails.logger.error "Failed to get commit hash from #{repo_clone_path}" if exit_status.exitstatus != 0
      commit_hash
    end
  end
end
