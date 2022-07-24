# frozen_string_literal: true

require 'fileutils'

class RepositoryCheck
  def self.download(repository)
    repo_clone_path = "#{Rails.root}/tmp/repositories/#{repository.owner_name}_#{repository.name}"
    FileUtils.rm_rf(repo_clone_path)
    command = "git clone #{repository.link} #{repo_clone_path}"
    stderr, exit_status = Open3.popen3(command) do |_stdin, _stdout, stderr, wait_thr|
      [stderr.read, wait_thr.value]
    end
    if exit_status.exitstatus != 0 && stderr.present?
      Rails.logger.error("Failed to clone repository #{repository.link} to #{repo_clone_path}")
      Rails.logger.error("stderr: #{stderr}")
    end
    repo_clone_path
  end

  def self.check(repository_path, linter)
    linter_command = case linter
                     when 'eslint'
                       "npx eslint --no-eslintrc --format json #{repository_path}"
                     when 'rubocop'
                       "rubocop --format json #{repository_path}/*"
                     end
    stdout, stderr, exit_status = Open3.popen3(linter_command) do |_stdin, stdout, stderr, wait_thr|
      [stdout.read, stderr.read, wait_thr.value]
    end
    if exit_status.exitstatus != 0 && stderr.present?
      Rails.logger.warn("#{linter_command} did not complete successfully")
      Rails.logger.warn("stderr: #{stderr}")
    end
    # since stdout will be put into check.output,
    # we must set it to nil because JSON.parse("") throws an error
    stdout = nil if stdout.empty?
    [stdout, exit_status.exitstatus]
  end
end
