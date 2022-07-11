# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_checks
#
#  id            :integer          not null, primary key
#  aasm_state    :string
#  linter        :string
#  output        :text
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
    state :checking, :passed, :failed

    event :check do
      transitions to: :checking
    end

    event :pass do
      transitions from: :checking, to: :passed
    end

    event :fail do
      transitions from: :checking, to: :failed
    end
  end
end
