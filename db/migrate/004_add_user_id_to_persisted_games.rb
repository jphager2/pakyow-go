class AddUserIdToPersistedGames < ActiveRecord::Migration
  add_column :persisted_games, :user_id, :integer
end
