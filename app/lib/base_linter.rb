# frozen_string_literal: true

class BaseLinter
  def self.lint(repository_path)
    cmd = "#{linter_command} #{repository_path}"
    stdout, stderr, exit_status = Open3.popen3(cmd) do |_stdin, stdout, stderr, wait_thr|
      [stdout.read, stderr.read, wait_thr.value]
    end
    [stdout, stderr, exit_status.exitstatus]
  end

  def self.linter_command; end
end
