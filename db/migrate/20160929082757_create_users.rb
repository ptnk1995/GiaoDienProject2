class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :remember_digest
      t.string :email
      t.string :image, default: "avatar.jpg"
      t.integer :role, default: 2

      t.timestamps
    end
  end
end
