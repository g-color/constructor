class CreateEstimates < ActiveRecord::Migration[5.0]
  def change
    create_table :estimates do |t|
      t.string :name, null: false
      t.references :client, null: false
      t.decimal :floors
      t.decimal :first_floor_height
      t.decimal :second_floor_height_min, default: 0
      t.decimal :second_floor_height_max, default: 0
      t.decimal :third_floor_height_min, default: 0
      t.decimal :third_floor_height_max, default: 0
      t.decimal :price
      t.decimal :area
      t.decimal :price_by_area
      t.decimal :price_by_stage, array: true, default: [0, 0, 0]
      t.decimal :price_by_stage_aggregated, array: true, default: [0, 0, 0]
      t.decimal :price_by_area_per_stage, array: true, default: [0, 0, 0]
      t.string  :discount_title
      t.decimal :discount_by_stages, array: true, default: [0, 0, 0]
      t.decimal :discount_amount, array: true, default: [0, 0, 0]
      t.decimal :price_by_stage_aggregated_discounted, array: true, default: [0, 0, 0]
      t.decimal :price_by_area_per_stage_discounted, array: true, default: [0, 0, 0]
      t.boolean :signed, null: false, default: false
      t.boolean :signing_date

      t.datetime :deleted_at
    end
  end
end
