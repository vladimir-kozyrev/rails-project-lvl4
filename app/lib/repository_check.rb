# frozen_string_literal: true

require 'fileutils'
require 'securerandom'

class RepositoryCheck
  def self.download(repository)
    repo_clone_path = "#{Rails.root}/tmp/repositories/#{SecureRandom.uuid}"
    command = "git clone #{repository.link} #{repo_clone_path}"
    stderr, exit_status = Open3.popen3(command) do |_stdin, _stdout, stderr, wait_thr|
      [stderr.read, wait_thr.value]
    end
    if exit_status.exitstatus != 0 && stderr.present?
      Rails.logger.error "Failed to clone repository #{repository.link} to #{repo_clone_path}"
      Rails.logger.error "stderr: #{stderr}"
      FileUtils.rm_rf(repo_clone_path) and return [nil, nil]
    end
    repo_clone_path
  end

  def self.check(repository_path, language)
    linter_command = linter_command(language, repository_path)
    stdout, stderr, exit_status = lint(linter_command)
    if exit_status != 0 && stderr.present?
      Rails.logger.warn "#{linter_command} did not complete successfully"
      Rails.logger.warn "stderr: #{stderr}"
    end
    commit_hash = commit_hash(repository_path)
    [stdout, commit_hash, exit_status]
  ensure
    FileUtils.rm_rf(repository_path)
  end

  def self.linter_command(language, repository_path)
    case language
    when 'javascript'
      "#{Rails.root}/node_modules/eslint/bin/eslint.js --config #{Rails.root}/.eslintrc.yml --no-eslintrc --format json #{repository_path}"
    when 'ruby'
      "bundle exec rubocop --config #{Rails.root}/.rubocop.yml --format json #{repository_path}"
    end
  end

  def self.lint(command)
    stdout, stderr, exit_status = Open3.popen3(command) do |_stdin, stdout, stderr, wait_thr|
      [stdout.read, stderr.read, wait_thr.value]
    end
    [stdout, stderr, exit_status.exitstatus]
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
