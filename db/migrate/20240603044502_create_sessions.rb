class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.string :session_id
      t.string :end_point
      t.string :channel
      t.string :topic
      t.string :message_type

      t.timestamps
    end
  end
end
