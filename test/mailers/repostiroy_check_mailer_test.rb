# frozen_string_literal: true

require 'test_helper'

class RepostiroyCheckMailerTest < ActionMailer::TestCase
  test 'notify_about_failure' do
    mail = RepostiroyCheckMailer.notify_about_failure
    assert_equal 'Repository check failed', mail.subject
    assert_equal ['to@example.org'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Dear ', mail.body.encoded
  end
end
