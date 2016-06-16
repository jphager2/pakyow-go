Pakyow::App.routes do

  default '/' do
    # Replace game.board.board with persisted board
    # Replace game.moves with with persited moves
    @pgame ||= current_game
    game = @pgame.to_game
    data = @pgame.board_data

    view.scope(:game).apply({ pgame: @pgame })

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

  fn :tap_game_file do
    @file_name = "#{@pgame.name}.sgf"
    @file_path = "/tmp/#{@pgame.name}.sgf"
    File.open(@file_path, 'w') { |f| f.write(@game.to_sgf) }
    @file = File.open(@file_path, 'r')
  end

  fn :delete_game_file do
    File.delete(@file_path)
  end

  fn :tap_current_game do 
    @pgame = PersistedGame.find(params[:game_id])
    @game  = @pgame.to_game
  end

  fn :persist_current_game do
    @pgame.update_game(@game, true)
    redirect router.group(:game).path(:show, game_id: @pgame.id)
  end

  group :game do
    get :new, 'games/new' do
      new_game(Game.new(board: (params[:size] || 9).to_i))

      redirect router.path(:default)
    end

    get :undo, '/games/:game_id/undo', before: [:tap_current_game] do
      unless @game.instance_variable_get(:@moves).empty?
        @game.undo
        @pgame.update_game(@game, true)
      end

      redirect router.group(:game).path(:show, game_id: @pgame.id)
    end

    get :pass, '/games/:game_id/pass', before: [:tap_current_game], after: [:persist_current_game] do
      @game.__send__("#{@pgame.turn}_pass")
    end

    get :play, '/games/:game_id/play/:x/:y', before: [:tap_current_game], after: [:persist_current_game] do
      # Need to persist game.board.board and game.moves
      @game.__send__(
        @pgame.turn, Integer(params[:y]), Integer(params[:x])
      )
    end

    post :send_email, '/games/:game_id/email/send', before: [:tap_current_game, :tap_game_file], after: [:delete_game_file] do
      view.scope(:user).apply(@pgame.user)
      view.scope(:user_game).apply(@pgame)

      mailer = Pakyow::Mailer.new(view: view.view)
      mailer.message.subject = "#{@pgame.user.name} has sent you an SGF"
      mailer.message.add_file(@file_path)
      mailer.deliver_to(params[:email])

      redirect router.group(:user).path(:show, user_id: @pgame.user.id)
    end

    get :email, '/games/:game_id/email', before: [:tap_current_game] do
      view.scope(:email_game).apply(@pgame)
      view.scope(:link).apply({})
      view.scope(:user_game).apply([@pgame])
    end

    get :download, '/games/:game_id/download', before: [:tap_current_game, :tap_game_file], after: [:delete_game_file] do
      send(@file, 'txt/sgf', @file_name)
    end

    get :show, '/games/:game_id' do
      @pgame = current_or_guest_user.persisted_games.find_by(id: params[:game_id])

      reroute router.path(:default)
    end
  end

  get :login, '/login' do
    reroute router.group(:session).path(:new), :get
  end

  get :logout, '/logout' do
    reroute router.group(:session).path(:remove), :delete
  end
end

