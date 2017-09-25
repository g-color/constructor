class AddPriceToStageProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :stage_products, :price, :float
  end
end
