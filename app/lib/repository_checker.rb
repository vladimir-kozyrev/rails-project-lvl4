# frozen_string_literal: true

class RepositoryChecker
  def run(repository)
    repository_check = ApplicationContainer[:repository_check]
    repository_path = repository_check.download(repository)
    return false unless repository_path

    exit_code = repository_check.check(repository_path)
    return false if exit_code != 0

    true
  end
end
