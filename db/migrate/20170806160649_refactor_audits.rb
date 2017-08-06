class RefactorAudits < ActiveRecord::Migration[5.0]
  def change
    drop_table :audits

    create_table :audits do |t|
      t.references :user
      t.column :action, :string
      t.column :object_type, :string
      t.column :object_name, :string
      t.column :object_link, :string
      t.timestamps
    end
  end
end
