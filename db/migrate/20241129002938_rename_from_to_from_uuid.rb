class RenameFromToFromUuid < ActiveRecord::Migration[7.1]
  def change
    rename_column :break_down_structures, :from, :from_uuid
    rename_column :break_down_structures, :to, :to_uuid
  end
end
