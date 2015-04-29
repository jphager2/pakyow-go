require 'active_record'
require_relative '../../models/persisted_game.rb'

module Pakyow::Helpers
  # define methods here that are available from routes, bindings, etc

  def data_from_board(board)
    { rows: board.map.with_index { |row, x| 
      { columns: row.map.with_index { |col, y| 
        { stone: col.color, x: x, y: y } 
      }} 
    }}
  end

  def current_game
    if persisted_game? 
      persisted_game
    else
      persist_game(Game.new(board: 9))
      persisted_game
    end
  end

  def persisted_game
    PersistedGame.last
  end

  def persisted_game?
    !!PersistedGame.last
  end

  def persist_game(game, played = false)
    pgame = PersistedGame.last || PersistedGame.new
    pgame.set_board(game.board)
    pgame.set_moves(game.instance_variable_get(:@moves))
    pgame.set_next_turn if played
    pgame.save
  end 

  def test_game
    game = Game.new(board: 9)
    game.black(2,2)
    game.white(2,3)
    game.black(3,3)
    game.pass
    game.black(2,4)
    game.pass
    game.black(1,3)
    game
  end

  def db_conn
    ActiveRecord::Base.establish_connection(
      adapter:  config.app.adapter,
      database: config.app.database_url
    )
  end
end
