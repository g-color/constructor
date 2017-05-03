class CreateStageProductSets < ActiveRecord::Migration[5.0]
  def change
    create_table :stage_product_sets do |t|
      t.references :stage_product
      t.references :product_set
      t.boolean    :selected, default: false
      t.timestamps
    end
  end
end
