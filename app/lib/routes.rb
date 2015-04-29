Pakyow::App.routes do
  # define your routes here

  # see something working by uncommenting the line below
  # default do
  #   puts 'hello'
  # end
  
  get :new, '/new' do
    PersistedGame.destroy_all

    redirect '/'
  end

  get :play, '/play/:x/:y' do
    # Need to persist game.board.board and game.moves
    pgame = current_game
    game  = pgame.to_game
    game.send(pgame.turn, Integer(params[:y]), Integer(params[:x]))

    persist_game(game, true)

    redirect '/'
  end

  get '/' do
    # Replace game.board.board with persisted board
    # Replace game.moves with with persited moves
    game = current_game.to_game
    data = data_from_board(game.board.board)

    view.scope(:game).apply({})

    view.scope(:board).apply(data) do |rws, board_data|
      rws.scope(:row).apply(board_data[:rows]) do |cls, row_data|
        cls.scope(:column).apply(row_data[:columns])
      end
    end

    captures = game.captures
    data = { 
      black: { name: "jphager2", captures: captures[:white] },
      white: { name: "moax",     captures: captures[:black] }
    }
    view.scope(:white).apply(data[:white])
    view.scope(:black).apply(data[:black])
  end
end
