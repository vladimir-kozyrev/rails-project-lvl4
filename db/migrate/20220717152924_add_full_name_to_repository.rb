class AddFullNameToRepository < ActiveRecord::Migration[6.1]
  def change
    add_column :repositories, :full_name, :string
  end
end
