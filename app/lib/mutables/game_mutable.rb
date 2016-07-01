Pakyow::App.mutable :game do
  query :find do |id|
    PersistedGame.find(id)
  end

  query :find_by do |values|
    PersistedGame.find_by(values)
  end

  action :update do |pgame, game, played|
    pgame.update_game(game, played)
  end
end
