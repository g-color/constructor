class CreateUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :units do |t|
      t.string   :name, unique: true, null: false
      t.boolean  :product, default: false
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :units, :deleted_at
  end
end
