class AddOrderToStageProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :stage_products, :order, :decimal
  end
end
