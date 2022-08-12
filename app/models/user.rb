# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string
#  image_url  :string
#  name       :string
#  nickname   :string
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  has_many :repositories, dependent: :destroy

  validates :email, presence: true
  validates :token, presence: true

  def self.find_or_create_from_auth(auth)
    user = User.find_or_create_by(email: auth['info']['email'])
    user.image_url = auth['info']['image']
    user.name = auth['info']['name']
    user.nickname = auth['info']['nickname']
    user.token = auth['credentials']['token']
    user if user.save
  end

  def supported_repos
    # Do not select any organization-owned repositories and
    # select reositories which languages the app can handle.
    supported_languages = Repository.enumerized_attributes['language'].values
    Octokiter.repos(token).select do |r|
      l = r['language']&.downcase
      r['owner']['login'] == nickname && supported_languages.include?(l)
    end
  end
end
