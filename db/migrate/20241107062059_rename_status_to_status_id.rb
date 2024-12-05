class RenameStatusToStatusId < ActiveRecord::Migration[7.1]
  def change
    rename_column :functional_locations, :status, :status_id
  end
end
