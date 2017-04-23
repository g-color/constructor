class CreateComposites < ActiveRecord::Migration[5.0]
  def change
    create_table   :composites do |t|
      t.string     :name, unique: true, null: false
      t.references :unit
      t.references :category
      t.decimal    :price
      t.boolean    :divisibility
      t.json       :parts
      t.datetime   :deleted_at
      t.timestamps
    end

    add_index :composites, :deleted_at
  end
end
