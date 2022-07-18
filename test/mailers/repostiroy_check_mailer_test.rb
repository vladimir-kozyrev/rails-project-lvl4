# frozen_string_literal: true

require 'test_helper'

class RepostiroyCheckMailerTest < ActionMailer::TestCase
  test 'notify_about_failure' do
    mail = RepostiroyCheckMailer.notify_about_failure
    assert_equal 'Notify about failure', mail.subject
    assert_equal ['to@example.org'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Hi', mail.body.encoded
  end
end
