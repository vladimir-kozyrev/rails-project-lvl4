class AddCommitHashToRepositoryChecks < ActiveRecord::Migration[6.1]
  def change
    add_column :repository_checks, :commit_hash, :string
  end
end
