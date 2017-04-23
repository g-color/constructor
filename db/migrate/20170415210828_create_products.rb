class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string     :name, unique: true, null: false
      t.text       :description
      t.text       :hint
      t.references :unit, null: false
      t.references :category, null: false
      t.integer    :stage, null: false
      t.boolean    :custom, default: false
      t.boolean    :display_components, default: false
      t.decimal    :profit

      t.datetime   :deleted_at
      t.timestamps
    end

    add_index :products, :deleted_at
    add_index :compositions, :deleted_at
  end
end
