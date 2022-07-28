# frozen_string_literal: true

class Web::AuthControllerTest < ActionDispatch::IntegrationTest
  test 'check github auth' do
    post auth_request_path('github')
    assert_response :redirect
  end

  test 'create' do
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: Faker::Internet.email,
        image: Faker::Internet.url,
        name: Faker::Name.first_name,
        nickname: Faker::Internet.username
      },
      credentials: {
        token: Faker::Blockchain::Bitcoin.address
      }
    }

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_url('github')
    assert_response :redirect

    user = User.find_by(email: auth_hash[:info][:email].downcase)

    assert user
    assert signed_in?
  end

  test 'sign out' do
    user = users(:joe)
    sign_in(user)
    assert signed_in?
    sign_out
    assert_not signed_in?
  end
end
