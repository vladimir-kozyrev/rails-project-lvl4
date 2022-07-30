# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  include Rails.application.routes.url_helpers

  queue_as :default

  def perform(check)
    if check.may_check?
      check.check!
    else
      check.fail!
      return
    end
    check.passed = RepositoryChecker.run(check)
    check.may_finish? ? check.finish! : check.fail!
  rescue StandardError => e
    check.fail!
    Rails.logger.error(e.message)
    e.backtrace.each { |line| Rails.logger.error(line) }
  ensure
    notify_about_failure(check) unless check.passed?
  end
end

private

def notify_about_failure(check)
  repository = check.repository
  user = repository.user
  RepostiroyCheckMailer.with(
    name: user.name,
    email: user.email,
    check_url: repository_check_url(repository, check)
  ).notify_about_failure.deliver_later
end
