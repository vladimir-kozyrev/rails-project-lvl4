# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    sign_in(users(:joe))
  end

  test 'should get index' do
    get repositories_url
    assert_response :success
  end

  test 'should get show' do
    get repository_url(repositories(:ruby))
    assert_response :success
  end

  test 'should get new' do
    get new_repository_url
    assert_response :success
  end

  test 'should create repository' do
    repo_id = 1_296_269
    post repositories_url, params: { repository: { github_id: repo_id } }
    assert_response :redirect
    assert { Repository.find_by(github_id: repo_id) }
  end
end
