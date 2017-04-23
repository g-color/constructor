class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name,  :string, null: false
    add_column :users, :crm,        :string, null: false
    add_column :users, :phone,      :string, null: false
  end
end
