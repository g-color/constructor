class CreateObjects < ActiveRecord::Migration[5.0]
  def change
    create_table :constructor_objects do |t|
      t.string     :name, unique: true, null: false
      t.references :unit, null: false
      t.references :category, null: false
      t.decimal    :price
      t.boolean    :is_primitive, default: true

      # primitive
      t.datetime   :date

      # object
      t.boolean    :divisibility, default: false

      t.datetime   :deleted_at
      t.timestamps
    end

    add_index :constructor_objects, :deleted_at
  end

end
