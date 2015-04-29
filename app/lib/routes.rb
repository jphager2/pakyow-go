Pakyow::App.routes do
  # define your routes here

  # see something working by uncommenting the line below
  default '/' do
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

  group :game do
    get :new, '/new' do
      PersistedGame.destroy_all

      redirect router.path(:default)
    end

    get :play, '/play/:x/:y' do
      # Need to persist game.board.board and game.moves
      pgame = current_game
      game  = pgame.to_game
      game.send(pgame.turn, Integer(params[:y]), Integer(params[:x]))

      persist_game(game, true)

      redirect router.path(:default)
    end
  end

  restful :user, '/users' do
    new do
      view.scope(:user).with do |view|
        view.bind(@user || User.new)
        handle_errors(view)
      end
    end

    create do
      @user = User.new(params[:user])

      if @user.valid?
        @user.save
        redirect router.path(:default)
      else
        @errors = @user.errors
        reroute router.group(:user).path(:new), :get
      end
    end
  end

  restful :session, '/sessions' do
    new do
      redirect router.path(:default) if session[:user]
      view.scope(:session).with do |view|
        view.bind(@session || Session.new)
        handle_errors(view)
      end
    end

    create do
      @session = Session.new(params[:session])

      if user = User.auth(@session)
        session[:user] = user.id
        redirect router.path(:default)
      else
        @errors = ['Invalid email and/or password']
        reroute router.group(:session).path(:new), :get
      end
    end

    remove do
      session[:user] = nil
      redirect router.path(:default)
    end
  end

  get :login, '/login' do
    reroute router.group(:session).path(:new), :get
  end

  get :logout, '/logout' do
    reroute router.group(:session).path(:remove), :delete
  end
end
