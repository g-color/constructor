class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string   :name, unique: true, null: false
      t.boolean  :product, default: false
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :categories, :deleted_at
  end
end
