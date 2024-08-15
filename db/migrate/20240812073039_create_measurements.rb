class CreateMeasurements < ActiveRecord::Migration[7.1]
  def change
    create_table :measurements do |t|
      t.references :equipment, null: false, foreign_key: true
      t.string :time_stamp
      t.string :data

      t.timestamps
    end
  end
end
