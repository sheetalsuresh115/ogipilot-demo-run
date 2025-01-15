class RenameTypeToAssetType < ActiveRecord::Migration[7.1]
  def change
    rename_column :equipment, :type, :asset_type
  end
end
