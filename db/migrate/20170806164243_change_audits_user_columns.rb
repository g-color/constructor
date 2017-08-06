class ChangeAuditsUserColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :audits, :user_id, :integer

    add_column :audits, :user_name, :string
    add_column :audits, :user_role, :string
  end
end
