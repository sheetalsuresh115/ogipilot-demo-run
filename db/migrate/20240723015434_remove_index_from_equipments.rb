class RemoveIndexFromEquipments < ActiveRecord::Migration[7.1]
  def change
    remove_index :equipment, :uuid
  end
end
