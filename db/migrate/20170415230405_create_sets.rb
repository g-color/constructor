class CreateSets < ActiveRecord::Migration[5.0]
  def change
    create_table :product_sets do |t|
      t.string   :name, null: false
      t.datetime :deleted_at
    end

    create_table :product_templates do |t|
      t.string   :name, null: false
      t.datetime :deleted_at
    end

    create_table :product_template_sets do |t|
      t.references :product, null: false
      t.references :product_template, null: false
      t.references :product_set, null: false
      t.datetime   :deleted_at
    end
  end
end
