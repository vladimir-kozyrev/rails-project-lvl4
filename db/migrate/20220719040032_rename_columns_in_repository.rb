class RenameColumnsInRepository < ActiveRecord::Migration[6.1]
  def change
    change_table :repositories do |t|
      t.rename :repo_name, :name
      t.integer :github_id, null: false
    end
  end
end
