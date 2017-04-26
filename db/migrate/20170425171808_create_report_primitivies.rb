class CreateReportPrimitivies < ActiveRecord::Migration[5.0]
  def change
    create_table :report_primitives do |t|
      t.references :constructor_object, null: false, foreign_key: true
      t.references :estimate, null: false, foreign_key: true
      t.integer :amount, null: false, default: 0
      t.datetime :signing_date

      t.timestamps
    end
  end
end
