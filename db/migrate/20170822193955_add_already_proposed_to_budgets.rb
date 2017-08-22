class AddAlreadyProposedToBudgets < ActiveRecord::Migration[5.0]
  def change
    add_column :budgets, :already_proposed, :bool, default: false
  end
end
