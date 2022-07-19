# frozen_string_literal: true

require 'test_helper'

class RepostiroyCheckMailerTest < ActionMailer::TestCase
  test 'notify_about_failure' do
    mail = RepostiroyCheckMailer.with(
      name: 'Unicorn',
      email: 'unicorn@test.io',
      check_url: 'test.io/repositories/1/checks/5'
    ).notify_about_failure
    assert_equal 'Repository check failed', mail.subject
    assert_equal ['unicorn@test.io'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Unicorn', mail.body.encoded
    assert_match 'test.io/repositories/1/checks/5', mail.body.encoded
  end
end
