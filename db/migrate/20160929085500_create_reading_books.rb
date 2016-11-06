class CreateReadingBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :reading_books do |t|
      t.boolean :reading
      t.boolean :favorite
      t.references :user, foreign_key: true
      t.references :book, foreign_key: true

      t.timestamps
    end
  end
end
