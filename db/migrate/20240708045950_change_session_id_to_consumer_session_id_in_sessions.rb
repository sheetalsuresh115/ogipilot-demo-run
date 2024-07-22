class ChangeSessionIdToConsumerSessionIdInSessions < ActiveRecord::Migration[7.1]
  def change
    rename_column :sessions, :session_id, :consumer_session_id
  end
end
