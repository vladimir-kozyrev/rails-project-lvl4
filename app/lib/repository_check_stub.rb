# frozen_string_literal: true

class RepositoryCheckStub
  def self.download(_)
    true
  end

  def self.check(_repository_path, _linter)
    ['', 0]
  end
end
