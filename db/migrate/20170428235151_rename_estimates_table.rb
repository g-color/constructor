class RenameEstimatesTable < ActiveRecord::Migration[5.0]
  def change
    rename_table :estimates, :budgets

    add_column :budgets, :type, :string
    add_column :budgets, :url,  :string
    add_column :budgets, :proposed, :boolean, default: false
    add_column :budgets, :proposer_id, :integer, :references => :users, foreign_key: true, null: true

    rename_column :stages,          :estimate_id, :budget_id
    rename_column :client_files,    :estimate_id, :budget_id
    rename_column :technical_files, :estimate_id, :budget_id

    change_column_null :budgets, :client_id, true
  end
end
