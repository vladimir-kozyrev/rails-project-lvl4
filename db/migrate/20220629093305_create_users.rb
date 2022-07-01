class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :image_url
      t.string :name
      t.string :nickname
      t.string :token

      t.timestamps
    end
  end
end
