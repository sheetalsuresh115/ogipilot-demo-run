class AddShortNameToBreakDownStructure < ActiveRecord::Migration[7.1]
  def change
    add_column :break_down_structures, :short_name, :string
    add_column :break_down_structures, :functional_location_id, :string
    add_foreign_key :break_down_structures, :functional_locations
  end
end
