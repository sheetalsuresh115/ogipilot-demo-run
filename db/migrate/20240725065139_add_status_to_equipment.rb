class AddStatusToEquipment < ActiveRecord::Migration[7.1]
  def change
    add_column :equipment, :status_id, :string
  end
end
