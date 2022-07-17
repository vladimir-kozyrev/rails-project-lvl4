# frozen_string_literal: true

# == Schema Information
#
# Table name: repositories
#
#  id              :integer          not null, primary key
#  default_branch  :string
#  description     :text
#  full_name       :string
#  language        :string
#  link            :string
#  owner_name      :string
#  repo_created_at :datetime
#  repo_name       :string
#  repo_updated_at :datetime
#  watchers_count  :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :integer          not null
#
# Indexes
#
#  index_repositories_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Repository < ApplicationRecord
  belongs_to :user
  has_many :checks

  extend Enumerize
  enumerize :language, in: %w[JavaScript Ruby]
end
