class AddTypeToEquipment < ActiveRecord::Migration[7.1]
  def change
    add_column :equipment, :type, :string
    add_column :equipment, :manufacturer, :string
    add_column :equipment, :model, :string
    add_column :equipment, :serial_number, :string
    add_foreign_key :equipment, :functional_locations
  end
end
