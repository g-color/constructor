class AddWithoutWorkPriceToConstructorObject < ActiveRecord::Migration[5.0]
  def change
    add_column    :constructor_objects, :price_without_work, :decimal, default: 0
    add_column    :stage_products,      :with_work,          :boolean, default: true
    add_column    :stage_products,      :price_without_work, :decimal, default: 0
    rename_column :stage_products,      :price,              :price_with_work
  end
end
