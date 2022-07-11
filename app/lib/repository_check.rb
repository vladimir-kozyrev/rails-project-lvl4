# frozen_string_literal: true

require 'fileutils'
class RepositoryCheck
  def self.download(repository)
    repo_clone_path = "#{Rails.root}/tmp/repositories/#{repository.owner_name}_#{repository.repo_name}"
    FileUtils.rm_rf(repo_clone_path)
    command = "git clone #{repository.link} #{repo_clone_path}"
    exit_status = Open3.popen3(command) do |_stdin, _stdout, _stderr, wait_thr|
      wait_thr.value
    end
    return false if exit_status.exitstatus != 0

    repo_clone_path
  end

  def self.check(repository_path)
    command = "npx eslint --no-eslintrc --format json #{repository_path}"
    stdout, exit_status = Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
      [stdout.read, wait_thr.value]
    end
    [stdout, exit_status.exitstatus]
  end
end
