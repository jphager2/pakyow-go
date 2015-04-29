
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
end
