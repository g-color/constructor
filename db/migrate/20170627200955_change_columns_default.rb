class ChangeColumnsDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default :budgets, :second_floor_height_min, 0
    change_column_default :budgets, :second_floor_height_max, 0
    change_column_default :budgets, :third_floor_height_min, 0
    change_column_default :budgets, :third_floor_height_max, 0
  end
end
