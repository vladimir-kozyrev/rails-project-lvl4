# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/repostiroy_check_mailer
class RepostiroyCheckMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/repostiroy_check_mailer/notify_about_failure
  def notify_about_failure
    RepostiroyCheckMailer.notify_about_failure
  end
end
