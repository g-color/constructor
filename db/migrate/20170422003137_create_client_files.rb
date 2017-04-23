class CreateClientFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :asset_files do |t|
      t.attachment :data
    end
    create_table :client_files do |t|
      t.references :estimate, null: false, foreign_key: true
      t.references :asset_file, null: false, foreign_key: true
    end
    create_table :technical_files do |t|
      t.references :estimate, null: false, foreign_key: true
      t.references :asset_file, null: false, foreign_key: true
    end
  end
end
