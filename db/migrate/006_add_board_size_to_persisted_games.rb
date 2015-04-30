class AddBoardSizeToPersistedGames < ActiveRecord::Migration
  add_column :persisted_games, :board_size, :integer
end
