# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get repositories_url
    assert_response :success
  end
end
