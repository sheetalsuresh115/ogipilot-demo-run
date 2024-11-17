class AddProviderSessionIdToSession < ActiveRecord::Migration[7.1]
  def change
    add_column :sessions, :provider_session_id, :string
  end
end
