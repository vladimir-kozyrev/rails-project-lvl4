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
    get repository_url(repositories(:two))
    assert_response :success
  end

  test 'should get new' do
    stubbed_response = load_fixture('octokit_response.json')
    stub_request(:get, 'https://api.github.com/user/repos?per_page=100')
      .to_return(status: 200, body: "[#{stubbed_response}]", headers: { 'Content-Type': 'application/json' })

    get new_repository_url
    assert_response :success
  end

  test 'should create repository' do
    repo_full_name = 'TheAlgorithms/JavaScript'

    stubbed_response = load_fixture('octokit_response.json')
    stub_request(:get, "https://api.github.com/repos/#{repo_full_name}")
      .to_return(status: 200, body: stubbed_response, headers: { 'Content-Type': 'application/json' })

    post repositories_url, params: { repository: { full_name: repo_full_name } }
    assert_response :redirect
    assert { Repository.find_by(full_name: repo_full_name) }
  end
end
