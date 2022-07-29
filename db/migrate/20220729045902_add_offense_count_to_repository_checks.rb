class AddOffenseCountToRepositoryChecks < ActiveRecord::Migration[6.1]
  def change
    add_column :repository_checks, :offense_count, :integer, default: 0
  end
end
