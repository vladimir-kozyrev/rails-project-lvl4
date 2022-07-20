# frozen_string_literal: true

class RepositoryCheckStub
  def self.download(_)
    true
  end

  def self.check(_repository_path, linter)
    case linter
    when 'eslint'
      [File.read('test/fixtures/files/eslint_check_result.json'), 0]
    when 'rubocop'
      [File.read('test/fixtures/files/rubocop_check_result.json'), 0]
    end
  end
end
