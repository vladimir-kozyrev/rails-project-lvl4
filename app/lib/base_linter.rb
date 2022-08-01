# frozen_string_literal: true

class BaseLinter
  def self.lint(repository_path)
    cmd = "#{linter_command} #{repository_path}"
    stdout, exit_status = Open3.popen3(cmd) do |_stdin, stdout, _stderr, wait_thr|
      [stdout.read, wait_thr.value]
    end
    [stdout, exit_status.exitstatus]
  end

  def self.linter_command
    raise NotImplementedError
  end
end
