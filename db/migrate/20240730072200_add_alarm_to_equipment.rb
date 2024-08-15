class AddAlarmToEquipment < ActiveRecord::Migration[7.1]
  def change
    add_column :equipment, :alarm_id, :string
  end
end
