class RemoveLinterFromRepositoryChecks < ActiveRecord::Migration[6.1]
  def change
    remove_column :repository_checks, :linter
  end
end
