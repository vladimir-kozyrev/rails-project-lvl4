# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(check)
    check.fetch! if check.may_fetch?
    check.linter = linter(check.repository.language)
    if RepositoryChecker.new.run(check) && check.may_mark_as_fetched?
      check.mark_as_fetched!
    elsif check.may_fail?
      check.fail!
    end
  rescue StandardError => e
    Rails.logger.error(e.message)
    check.fail! if check.may_fail?
  end
end

private

def linter(language)
  case language
  when 'JavaScript'
    'eslint'
  end
end
