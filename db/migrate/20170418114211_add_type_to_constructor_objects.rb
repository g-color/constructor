class AddTypeToConstructorObjects < ActiveRecord::Migration[5.0]
  def change
    add_column :constructor_objects, :type, :string
  end
end
