# frozen_string_literal: true

# == Schema Information
#
# Table name: repositories
#
#  id              :integer          not null, primary key
#  default_branch  :string
#  description     :text
#  language        :string
#  link            :string
#  owner_name      :string
#  repo_created_at :datetime
#  repo_name       :string
#  repo_updated_at :datetime
#  watchers_count  :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
