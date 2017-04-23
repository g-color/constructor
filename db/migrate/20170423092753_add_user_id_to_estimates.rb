class AddUserIdToEstimates < ActiveRecord::Migration[5.0]
  def change
  	add_column :estimates, :user_id , :integer, :references => "users", foreign_key: true
  end
end
