class RenameTypeToAttributeType < ActiveRecord::Migration[7.1]
  def change
    rename_column :actual_events, :type, :attribute_type
    rename_column :actual_events, :group, :group_uuid
  end
end
