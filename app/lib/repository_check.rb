# frozen_string_literal: true

require 'fileutils'
require 'securerandom'

# rubocop:disable Metrics/ClassLength
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
      FileUtils.rm_rf(repo_clone_path) and return [nil, nil]
    end
    repo_clone_path
  end

  def self.check(repository_path, check)
    language = check.repository.language
    linter_command = linter_command(language, repository_path)
    stdout, stderr, exit_status = lint(linter_command)
    if exit_status != 0 && stderr.present?
      Rails.logger.warn "#{linter_command} did not complete successfully"
      Rails.logger.warn "stderr: #{stderr}"
    end
    stdout_json = JSON.parse(stdout.presence || '[]')
    check.output = format_output(stdout_json, language).to_json
    check.offense_count = offense_count(stdout_json, language)
    check.commit_hash = commit_hash(repository_path)
    exit_status
  ensure
    FileUtils.rm_rf(repository_path)
  end

  def self.linter_command(language, repository_path)
    case language
    when 'javascript'
      eslint = Rails.root.join('node_modules/eslint/bin/eslint.js')
      "#{eslint} --config #{Rails.root}/.eslintrc.yml --no-eslintrc --format json #{repository_path}"
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

  def self.format_output(check_output, language)
    case language
    when 'javascript'
      format_eslint_output(check_output)
    when 'ruby'
      format_rubocop_output(check_output)
    else
      {}
    end
  end

  def self.format_eslint_output(check_output)
    formatted_output = {}
    check_output.each do |issue|
      next if issue['messages'].empty?

      file_path = issue['filePath']
      formatted_output[file_path] = []
      issue['messages'].each do |issue_messages|
        formatted_output[file_path].append(
          {
            message: issue_messages['message'],
            rule: issue_messages['ruleId'],
            line_column: "#{issue_messages['line']}:#{issue_messages['column']}"
          }
        )
      end
    end
    formatted_output
  end

  def self.format_rubocop_output(check_output)
    return {} if check_output.empty?

    formatted_output = {}
    check_output['files'].each do |file|
      next if file['offenses'].empty?

      file_path = file['path']
      formatted_output[file_path] = []
      file['offenses'].each do |offence|
        formatted_output[file_path].append(
          {
            message: offence['message'],
            rule: offence['cop_name'],
            line_column: "#{offence['location']['line']}:#{offence['location']['column']}"
          }
        )
      end
    end
    formatted_output
  end

  def self.offense_count(check_output, language)
    case language
    when 'ruby'
      check_output.dig('summary', 'offense_count') || 0
    when 'javascript'
      check_output.inject(0) { |count, file| file['messages'].size + count }
    end
  end
end
# rubocop:enable Metrics/ClassLength
