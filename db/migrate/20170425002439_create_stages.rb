class CreateStages < ActiveRecord::Migration[5.0]
  def change
    create_table :stages do |t|
      t.references :estimate
      t.integer    :number
      t.decimal    :price
      t.decimal    :total_price
      t.timestamps
    end
  end
end
