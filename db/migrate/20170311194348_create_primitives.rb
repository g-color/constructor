class CreatePrimitives < ActiveRecord::Migration[5.0]
  def change
    create_table :primitives do |t|
      t.string     :name, unique: true, null: false
      t.references :unit
      t.references :category
      t.decimal    :price
      t.datetime   :date
      t.datetime   :deleted_at
      t.timestamps
    end

    add_index :primitives, :deleted_at
  end
end
