class CreateProductCompositions < ActiveRecord::Migration[5.0]
  def change
    create_table :product_compositions do |t|
      t.references :product
      t.references :constructor_object
      t.integer :value

      t.datetime :deleted_at
    end
  end
end
