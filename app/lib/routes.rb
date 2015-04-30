Pakyow::App.routes do
  # define your routes here

  # see something working by uncommenting the line below
  default '/' do
    # Replace game.board.board with persisted board
    # Replace game.moves with with persited moves
    @pgame ||= current_game
    game = @pgame.to_game
    data = data_from_board(game.board.board)

    view.scope(:game).apply({})

    view.scope(:board).apply(data) do |rws, board_data|
      rws.scope(:row).apply(board_data[:rows]) do |cls, row_data|
        cls.scope(:column).apply(row_data[:columns])
      end
    end

    view.scope(:white).with do |view|
      view.prop(:turn).remove unless @pgame.white_turn?
    end 

    view.scope(:black).with do |view|
      view.prop(:turn).remove unless @pgame.black_turn?
    end 

    captures = game.captures
    data = { 
      black: { name: "Player 1", captures: captures[:white] },
      white: { name: "Player 2",     captures: captures[:black] }
    }

    unless @pgame.user.guest?
      data[:black][:name] = data[:white][:name] = @pgame.user.name
    end
    view.scope(:white).apply(data[:white])
    view.scope(:black).apply(data[:black])
  end

  fn :tap_current_game do 
    @pgame = current_game
    @game  = @pgame.to_game
  end

  fn :persist_current_game do
    persist_game(@game, true)
    redirect router.path(:default)
  end

  group :game do
    get :new, '/new' do
      new_game(Game.new(board: 9))

      redirect router.path(:default)
    end

    get :undo, '/undo', before: [:tap_current_game] do
      unless @game.instance_variable_get(:@moves).empty?
        @game.undo
        persist_game(@game, true)
      end

      redirect router.path(:default)
    end

    get :pass, '/pass', before: [:tap_current_game], after: [:persist_current_game] do
      @game.__send__("#{@pgame.turn}_pass")
    end

    get :play, '/play/:x/:y', before: [:tap_current_game], after: [:persist_current_game] do
      # Need to persist game.board.board and game.moves
      @game.__send__(
        @pgame.turn, Integer(params[:y]), Integer(params[:x])
      )
    end

    get :download, '/download', before: [:tap_current_game] do
      file_name = "tmp/game-#{@pgame.id}.sgf"
      File.open(file_name, 'w') { |f| f.write(@game.to_sgf) }
      file = File.open(file_name, 'r')
      File.delete(file_name)

      send(file, 'txt/sgf', file_name)
    end

    get :show, '/games/:game_id' do
      @pgame = current_or_guest_user.persisted_games.find_by(id: params[:game_id])

      reroute router.path(:default)
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
        if session[:guest_user]
          @user.persisted_games = current_guest_user.persisted_games
          current_guest_user.destroy
          session[:guest_user] = nil
        end
        
        redirect router.path(:default)
      else
        @errors = @user.errors
        reroute router.group(:user).path(:new), :get
      end
    end

    show do
      @user = current_or_guest_user

      unless @user.id == params[:user_id].to_i
        redirect router.path(:default) 
      end

      view.scope(:user_game).apply(@user.persisted_games)
    end
  end

  restful :session, '/sessions' do
    new do
      redirect router.path(:default) if session[:user]
      view.scope(:session).with do |view|
        view.bind(@session || Session.new)
        handle_errors(view)
      end

      view.scope(:link).apply({})
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
