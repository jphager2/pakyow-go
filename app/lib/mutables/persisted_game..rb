require_relative "../persisted_game"

Pakyow::App.mutable :persisted_game do
  model PersistedGame

  action :update_game do |pgame, game, played|
    pgame.update_game(game, played)
  end

  query :current_game do |user, id|
    user.persisted_games.find_by(id: id)
  end

  query :all do
    PersistedGame.all
  end

  query :find do |id|
    PersistedGame.find(id)
  end
end
