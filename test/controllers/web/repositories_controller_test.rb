# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get repositories_url
    assert_response :success
  end

  test 'should get show' do
    sign_in(users(:one))
    get repository_url(repositories(:one))
    assert_response :success
  end

  test 'should get new' do
    sign_in(users(:one))

    stubbed_response = load_fixture('../fixtures/files/response.json')
    stub_request(:get, 'https://api.github.com/user/repos')
      .to_return(status: 200, body: "[#{stubbed_response}]", headers: { 'Content-Type': 'application/json' })

    get new_repository_url
    assert_response :success
  end

  test 'should create repository' do
    sign_in(users(:one))
    repo_link = 'https://github.com/TheAlgorithms/JavaScript'
    repo_full_name = repo_link.delete_prefix('https://github.com/')

    stubbed_response = load_fixture('../fixtures/files/response.json')
    stub_request(:get, "https://api.github.com/repos/#{repo_full_name}")
      .to_return(status: 200, body: stubbed_response, headers: { 'Content-Type': 'application/json' })

    post repositories_url, params: { repository: { link: repo_link } }
    assert_response :redirect
    assert { Repository.find_by(link: repo_link) }
  end
end
