class AddForeignKeyFunctionalLocation < ActiveRecord::Migration[7.1]
  def change
    add_column :functional_locations, :break_down_structure_id, :string
    add_foreign_key :functional_locations, :break_down_structures
  end
end
