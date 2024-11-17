class CreateFunctionalLocation < ActiveRecord::Migration[7.1]
  def change
    create_table :functional_locations do |t|
      t.string :uuid
      t.string :description
      t.string :status
      t.string :segment_type
      t.string :id_in_source
      t.string :short_name
      t.string :alarm_id
      t.boolean :is_active

      t.timestamps
    end
  end
end
