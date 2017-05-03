class AddColumnsToStages < ActiveRecord::Migration[5.0]
  def change
    add_column    :stages, :price_with_discount, :decimal
    remove_column :stages, :total_price,         :decimal
  end
end
