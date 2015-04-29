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

  def handle_errors(view)
    if @errors
      render_errors(view, @errors)
    else
      view.scope(:errors).remove
    end
  end

  def render_errors(view, errors)
    unless errors.is_a?(Array)
      errors = pretty_errors(errors.full_messages)
    end

    view.scope(:errors).with do
      prop(:message).repeat(errors) { |context, message|
        context.text = message
      }
    end
  end

  def pretty_errors(errors)
    Array(errors).map { |error|error.gsub('_', ' ').capitalize }
  end
end
