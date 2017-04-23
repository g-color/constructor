class AddRolesToUsers < ActiveRecord::Migration[5.0]
  def change
    execute <<-SQL
      CREATE TYPE user_role AS ENUM ('admin', 'architector', 'engineer');
    SQL

    add_column :users, :role, :user_role, default: 'architector'
  end
end
