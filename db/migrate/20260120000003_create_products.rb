class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string  :name
      t.decimal :price, precision: 10, scale: 2
      t.date    :released_on
      t.integer :category_id
      t.timestamps null: false
    end

    add_index :products, :category_id
  end
end