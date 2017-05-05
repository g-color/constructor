class AddSolutionId < ActiveRecord::Migration[5.0]
  def change
    add_column :budgets, :solution_id, :integer, null: true
  end
end
