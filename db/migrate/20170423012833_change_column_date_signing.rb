class ChangeColumnDateSigning < ActiveRecord::Migration[5.0]
  def change
  	remove_column :estimates, :signing_date
    add_column :estimates, :signing_date, :date
  end
end
