class AddIsActiveToEquipment < ActiveRecord::Migration[7.1]
  def change
    add_column :equipment, :is_active, :boolean
  end
end
