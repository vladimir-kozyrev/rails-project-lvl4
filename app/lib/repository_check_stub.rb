# frozen_string_literal: true

class RepositoryCheckStub
  def self.download(_)
    true
  end

  def self.check(_)
    [File.read("#{Rails.root}/test/fixtures/files/eslint_check_result.json"), 1]
  end
end
