# frozen_string_literal: true

class RepositoryChecker
  def self.run(check)
    repository_check = ApplicationContainer[:repository_check]
    repository_path = repository_check.download(check.repository)
    unless repository_path
      Rails.logger.error "Failed to download repository to #{repository_path}"
      return false
    end

    exit_code = repository_check.check(repository_path, check)
    exit_code.zero?
  end
end
