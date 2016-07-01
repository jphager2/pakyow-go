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

    view.scope(:white).with do |view|
      view.prop(:turn).remove unless pgame.white_turn?
    end 

    view.scope(:black).with do |view|
      view.prop(:turn).remove unless pgame.black_turn?
    end 

    captures = game.captures
    players = { 
      black: { name: "Player 1", captures: captures[:white] },
      white: { name: "Player 2", captures: captures[:black] }
    }

    unless pgame.user.guest?
      players[:black][:name] = players[:white][:name] = pgame.user.name
    end
    view.scope(:white).apply(players[:white])
    view.scope(:black).apply(players[:black])
  end
end
