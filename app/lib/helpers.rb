module Pakyow::Helpers
  # define methods here that are available from routes, bindings, etc

  def current_user?
    !!current_user
  end

  def current_user
    User.find(session[:user]) if session[:user]
  rescue ActiveRecord::RecordNotFound
    session[:user] = nil
  end

  def current_guest_user
    if session[:guest_user]
      guest = GuestUser.find(session[:guest_user])
    else
      guest = GuestUser.new
      guest.save(validate: false)
      session[:guest_user] = guest.id
      guest
    end
  rescue ActiveRecord::RecordNotFound
    session[:guest_user] = nil
  end

  def current_or_guest_user
    current_user? ? current_user : current_guest_user
  end

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
    current_or_guest_user.persisted_games.last
  end

  def persisted_game?
    !!persisted_game
  end

  def new_game(game)
    PersistedGame.create(user_id: current_or_guest_user.id)
    persist_game(game)
  end

  def persist_game(game, played = false)
    if pgame = persisted_game
      pgame.set_board(game.board)
      pgame.set_moves(game.instance_variable_get(:@moves))
      pgame.set_next_turn if played
      pgame.user_id = current_or_guest_user.id
      pgame.save
    else
      new_game(game)
    end
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
