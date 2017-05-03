class CreateStageProductSetValues < ActiveRecord::Migration[5.0]
  def change
    create_table :stage_product_set_values do |t|
      t.references :stage_product_set
      t.references :product_template
      t.references :constructor_object
      t.integer    :quantity
      t.timestamps
    end
  end
end
