class CreatePersistedGamesTable < ActiveRecord::Migration
  def change
    create_table :persisted_games do |t|
      t.text :board
      t.text :moves
      t.boolean :black_turn, default: true
    end
  end
end
