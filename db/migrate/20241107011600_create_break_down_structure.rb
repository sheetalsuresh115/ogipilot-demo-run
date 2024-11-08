class CreateBreakDownStructure < ActiveRecord::Migration[7.1]
  def change
    create_table :break_down_structures do |t|
      t.string :uuid
      t.string :from
      t.string :to

      t.timestamps
    end
  end
end
