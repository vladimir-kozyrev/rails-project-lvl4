# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_checks
#
#  id            :integer          not null, primary key
#  aasm_state    :string
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
    state :fetching, :fetched, :failed

    event :fetch do
      transitions to: :fetching
    end

    event :mark_as_fetched do
      transitions from: :fetching, to: :fetched
    end

    event :fail do
      transitions from: :fetching, to: :failed
    end
  end
end
