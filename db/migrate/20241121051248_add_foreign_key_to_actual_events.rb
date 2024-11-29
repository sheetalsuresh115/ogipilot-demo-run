class AddForeignKeyToActualEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :actual_events, :functional_location_id, :string
    add_foreign_key :actual_events, :functional_locations
    remove_column :actual_events, :entity
  end
end
