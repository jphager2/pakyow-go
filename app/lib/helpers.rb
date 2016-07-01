module Pakyow::Helpers
  # define methods here that are available from routes, bindings, etc

  def current_user?
    current_user
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

  def current_game(size = 9)
    if persisted_game? 
      persisted_game
    else
      persist_game(Game.new(board: size))
      persisted_game
    end
  end

  def persisted_game
    data(:game)
      .find_by(current_or_guest_user.persisted_games.pluck(:id).last)
  end

  def persisted_game?
    persisted_game.data
  end

  def new_game(game)
    pgame = PersistedGame.create(user_id: current_or_guest_user.id)
    data(:game).update(pgame, game, false)
  end

  def persist_game(game, played = false)
    if persisted_game?
      persisted_game.data.update_game(game, played)
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
    Array(errors).map { |error| error.gsub('_', ' ').capitalize }
  end
end
