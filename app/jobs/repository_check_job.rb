# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(repository, check)
    check.fetch! if check.may_fetch?
    if RepositoryChecker.new.run(repository) && check.may_mark_as_fetched?
      check.mark_as_fetched!
    elsif check.may_fail?
      check.fail!
    end
  rescue StandardError => e
    Rails.logger.error(e.message)
    check.fail! if check.may_fail?
  end
end
