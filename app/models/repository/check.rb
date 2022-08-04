# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_checks
#
#  id            :integer          not null, primary key
#  aasm_state    :string
#  commit_hash   :string
#  offense_count :integer          default(0)
#  output        :text
#  passed        :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  repository_id :integer          not null
#
# Indexes
#
#  index_repository_checks_on_repository_id  (repository_id)
#
# Foreign Keys
#
#  repository_id  (repository_id => repositories.id)
#
class Repository::Check < ApplicationRecord
  belongs_to :repository

  include AASM

  aasm do
    state :created, initial: true
    state :checking, :finished, :failed

    event :run_check do
      transitions to: :checking
    end

    event :finish do
      transitions from: :checking, to: :finished
    end

    event :fail do
      transitions to: :failed
    end
  end
end
