class CreateUserClients < ActiveRecord::Migration[5.0]
  def change
    create_table :user_clients do |t|
      t.belongs_to :user,   index: true
      t.belongs_to :client, index: true
      t.boolean    :owner,  default: false
      t.timestamps
    end
  end
end
