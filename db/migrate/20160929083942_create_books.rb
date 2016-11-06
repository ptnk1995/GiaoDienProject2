class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :name
      t.text :description
      t.string :image
      t.date :publish_date
      t.string :author
      t.string :url
      t.integer :page
      t.float :rating, default: 0.0
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
