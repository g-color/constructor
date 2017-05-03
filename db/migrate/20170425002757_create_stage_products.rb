class CreateStageProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :stage_products do |t|
      t.references :product
      t.references :stage
      t.integer    :quantity
      t.decimal    :price
      t.timestamps
    end
  end
end
