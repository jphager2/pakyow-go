class AddTimestampsToPersistedGames < ActiveRecord::Migration
  change_table :persisted_games do |t|
    t.timestamps
  end
end
