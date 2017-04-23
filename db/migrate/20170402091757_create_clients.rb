class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string  :first_name,  null: false
      t.string  :last_name
      t.string  :middle_name
      t.string  :crm
      t.boolean :archived, default: false
      t.timestamps
    end
  end
end
