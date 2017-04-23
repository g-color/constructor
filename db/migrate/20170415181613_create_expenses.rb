class CreateExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :expenses do |t|
      t.string :name,     null: false
      t.decimal :percent, null: false
      t.timestamps
    end

    add_column :expenses, :deleted_at, :datetime
    add_index  :expenses, :deleted_at
  end
end
