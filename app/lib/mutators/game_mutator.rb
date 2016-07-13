Pakyow::App.mutators :game do
  mutator :show do |view, pgame|
    # view is the game scope
    # pgame is PersistedGame
   
    game = pgame.to_game
    board = pgame.board_data

    view.apply({ pgame: pgame })

    view.scope(:board).apply([board]) do |rws, board_data|
      rws.scope(:row).apply(board_data[:rows]) do |cls, row_data|
        cls.scope(:column).apply(row_data[:columns])
      end
    end

    captures = game.captures
    players = { 
      black: { name: "Player 1", captures: captures[:white], turn: pgame.black_turn? },
      white: { name: "Player 2", captures: captures[:black], turn: pgame.white_turn? }
    }

    unless pgame.user.guest?
      players[:black][:name] = players[:white][:name] = pgame.user.name
    end
    view.scope(:white).apply(players[:white])
    view.scope(:black).apply(players[:black])
  end
end
