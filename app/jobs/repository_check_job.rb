# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  include Rails.application.routes.url_helpers

  queue_as :default

  def perform(check)
    check.check! if check.may_check?
    check.passed = RepositoryChecker.run(check)
  ensure
    check.finish! if check.may_finish?
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
