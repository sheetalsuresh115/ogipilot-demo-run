class CreateActualEvent < ActiveRecord::Migration[7.1]
  def change
    create_table :actual_events do |t|
      t.string :uuid
      t.string :group
      t.string :type
      t.string :value
      t.string :uom
      t.string :entity

      t.timestamps
    end
  end
end
