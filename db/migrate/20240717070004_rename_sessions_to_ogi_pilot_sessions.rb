class RenameSessionsToOgiPilotSessions < ActiveRecord::Migration[7.1]
  def change
    rename_table :sessions, :ogi_pilot_sessions
  end
end
