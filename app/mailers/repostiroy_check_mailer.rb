# frozen_string_literal: true

class RepostiroyCheckMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.repostiroy_check_mailer.notify_about_failure.subject
  #
  def notify_about_failure
    @greeting = 'Hi'

    mail to: 'to@example.org'
  end
end
