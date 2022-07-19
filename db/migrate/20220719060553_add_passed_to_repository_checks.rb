class AddPassedToRepositoryChecks < ActiveRecord::Migration[6.1]
  def change
    add_column :repository_checks, :passed, :boolean, default: false
  end
end
