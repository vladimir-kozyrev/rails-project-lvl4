class RenameColumnsInRepository < ActiveRecord::Migration[6.1]
  def change
    change_table :repositories do |t|
      t.rename :full_name, :github_id
      t.rename :repo_name, :name
    end
  end
end
