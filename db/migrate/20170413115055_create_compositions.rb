class CreateCompositions < ActiveRecord::Migration[5.0]
  def change
    create_table :compositions do |t|
      t.integer :parent_id
      t.integer :children_id
      t.integer :value
    end
  end
end
