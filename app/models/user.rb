class User < ApplicationRecord
  validates :email, presence: true
  validates :image_url, presence: true
  validates :name, presence: true
  validates :nickname, presence: true
  validates :token, presence: true

  def self.find_or_create_by(auth_params)

  end
end
