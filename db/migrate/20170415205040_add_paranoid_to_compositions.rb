class AddParanoidToCompositions < ActiveRecord::Migration[5.0]
  def change
    add_column :compositions, :deleted_at, :datetime
  end
end
