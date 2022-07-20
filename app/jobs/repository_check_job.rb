# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  include Rails.application.routes.url_helpers

  queue_as :default

  def perform(check)
    check.check! if check.may_check?
    check.linter = linter_for(check.repository.language)
    check.passed = true if RepositoryChecker.new.run(check)
  rescue StandardError => e
    Rails.logger.error(e.message)
    raise
  ensure
    check.finish! if check.may_finish?
    notify_about_failure(check)
  end
end

private

def linter_for(language)
  case language
  when 'JavaScript'
    'eslint'
  when 'Ruby'
    'rubocop'
  end
end

def notify_about_failure(check)
  RepostiroyCheckMailer.with(
    name: check.repository.user.name,
    email: check.repository.user.email,
    check_url: repository_check_url(check.repository, check)
  ).notify_about_failure.deliver_later
end
