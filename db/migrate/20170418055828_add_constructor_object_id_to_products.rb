class AddConstructorObjectIdToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :product_template_sets, :constructor_object_id, :integer
  end
end
