class TypeForQuantity < ActiveRecord::Migration[5.0]
  def change
    drop_table :composites
    drop_table :primitives
    change_column :compositions, :value, :decimal
    change_column :stage_product_set_values, :quantity, :decimal
    change_column :stage_products, :quantity, :decimal
    change_column :product_compositions, :value, :decimal
  end
end
