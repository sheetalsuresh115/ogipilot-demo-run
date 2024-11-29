class AddUserNameToSessions < ActiveRecord::Migration[7.1]
  def change
    add_column :ogi_pilot_sessions, :user_name, :string
    add_column :ogi_pilot_sessions, :password_digest, :string
  end
end
