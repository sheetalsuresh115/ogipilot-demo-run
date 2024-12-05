class AddCommentsToEquipment < ActiveRecord::Migration[7.1]
  def change
    add_column :equipment, :comments, :string
  end
end
