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
  validates :email, presence: true
  # validates :image_url, presence: true
  validates :name, presence: true
  # validates :nickname, presence: true
  # validates :token, presence: true

  def self.find_or_create_from_auth(auth)
    user = User.find_or_create_by(email: auth['info']['email'])
    user.email = auth['info']['email']
    user.image_url = auth['info']['image']
    user.name = auth['info']['name']
    user.nickname = auth['info']['nickname']
    # user.token = auth['credentials']['token']
    user.save!
    user
  end
end
