class AddTimestampsToEstimates < ActiveRecord::Migration[5.0]
  def change
    add_timestamps :estimates
  end
end
