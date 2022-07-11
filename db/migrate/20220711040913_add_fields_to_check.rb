class AddFieldsToCheck < ActiveRecord::Migration[6.1]
  def change
    change_table :repository_checks do |t|
      t.string :linter
      t.text :output
    end
  end
end
