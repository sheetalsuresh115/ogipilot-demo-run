class AddIndexToEquipment < ActiveRecord::Migration[7.1]
  def change
    add_index :equipment, :uuid, unique: true
  end
end
