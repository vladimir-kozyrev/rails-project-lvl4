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
    stubbed_response = load_fixture('octokit_repo_response.json')
    stub_request(:get, 'https://api.github.com/user/repos?per_page=100')
      .to_return(status: 200, body: "[#{stubbed_response}]", headers: { 'Content-Type': 'application/json' })

    get new_repository_url
    assert_response :success
  end

  test 'should create repository' do
    repo_id = 1_296_269

    get_repo_template = Addressable::Template.new('https://api.github.com/repositories/{id}')
    stubbed_get_repo_response = load_fixture('octokit_repo_response.json')
    stub_request(:get, get_repo_template)
      .to_return(status: 200, body: stubbed_get_repo_response, headers: { 'Content-Type': 'application/json' })

    get_hook_template = Addressable::Template.new('https://api.github.com/repos/{owner_name}/{repo_name}/hooks?per_page=100')
    stubbed_get_hooks_respone = load_fixture('octokit_get_hooks_response.json')
    stub_request(:get, get_hook_template)
      .to_return(status: 200, body: stubbed_get_hooks_respone, headers: { 'Content-Type': 'application/json' })

    create_hook_template = Addressable::Template.new('https://api.github.com/repos/{owner_name}/{repo_name}/hooks')
    stubbed_create_hook_response = load_fixture('octokit_create_hook_response.json')
    stub_request(:post, create_hook_template)
      .to_return(status: 200, body: stubbed_create_hook_response, headers: { 'Content-Type': 'application/json' })

    post repositories_url, params: { repository: { github_id: repo_id } }
    assert_response :redirect
    assert { Repository.find_by(github_id: repo_id) }
  end
end
