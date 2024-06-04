class CreateEquipment < ActiveRecord::Migration[7.1]
  def change
    create_table :equipment do |t|
      t.string :uuid
      t.string :id_in_source
      t.string :functional_location_id
      t.string :segment_uuid
      t.string :site_id
      t.string :short_name
      t.string :properties
      t.string :installed_at
      t.string :datetime
      t.string :uninstalled_at
      t.string :category
      t.string :bod_content

      t.timestamps
    end
  end
end
