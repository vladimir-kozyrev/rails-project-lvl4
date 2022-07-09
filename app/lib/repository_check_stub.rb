# frozen_string_literal: true

class RepositoryCheckStub
  def self.download(_repository)
    true
  end

  def self.check(_repository)
    [File.read('../test/fixtures/files/eslint_check_result.json'), 0]
  end
end
