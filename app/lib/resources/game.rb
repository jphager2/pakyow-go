Pakyow::App.routes :game do
  fn :tap_game_file do
    @file_name = @pgame.data.name + '.sgf'
    tempfile = Tempfile.open('game_record')
    tempfile.write(@game.to_sgf)
    tempfile.rewind
    @file = tempfile.to_io
  end

  fn :tap_current_game do 
    @pgame = data(:game).find(params[:game_id])
    @game  = @pgame.data.to_game
  end

  fn :persist_current_game do
    data(:game).update(@pgame.data, @game, true)
    redirect router.group(:game).path(:show, game_id: @pgame.data.id)
  end

  group :game do
    get :new, 'games/new' do
      new_game(Game.new(board: (params[:size] || 9).to_i))

      redirect router.path(:default)
    end

    get :undo, '/games/:game_id/undo', before: [:tap_current_game] do
      unless @game.instance_variable_get(:@moves).empty?
        @game.undo
        data(:game).update(@pgame.data, @game, true)
      end

      redirect router.group(:game).path(:show, game_id: @pgame.data.id)
    end

    get :pass, '/games/:game_id/pass', before: [:tap_current_game], after: [:persist_current_game] do
      @game.pass(@pgame.data.turn)
    end

    post :play, '/games/:game_id/play/:x/:y', before: [:tap_current_game], after: [:persist_current_game] do
      begin
        @game.__send__(@pgame.data.turn, Integer(params[:y]), Integer(params[:x]))
      rescue Game::IllegalMove
        redirect router.group(:game).path(:show, game_id: @pgame.data.id)
      end
    end

    post :send_email, '/games/:game_id/email/send', before: [:tap_current_game, :tap_game_file] do
      view.scope(:user).apply(@pgame.data.user)
      view.scope(:user_game).apply(@pgame.data)

      mailer = Pakyow::Mailer.new(view: view.view)
      mailer.message.subject = "#{@pgame.data.user.name} has sent you an SGF"
      mailer.message.add_file(filename: @file_name, content: @file.read)
      mailer.deliver_to(params[:email])

      redirect router.group(:user).path(:show, user_id: @pgame.data.user.id)
    end

    get :email, '/games/:game_id/email', before: [:tap_current_game] do
      view.scope(:email_game).apply(@pgame.data)
      view.scope(:link).apply({})
      view.scope(:user_game).apply([@pgame.data])
    end

    get :download, '/games/:game_id/download', before: [:tap_current_game, :tap_game_file] do
      send(@file, 'txt/sgf', @file_name)
    end

    get :show, '/games/:game_id' do
      @pgame = data(:game).find_by(id: params[:game_id])

      if @pgame.data
        reroute router.path(:default)
      else
        redirect router.path(:default)
      end
    end
  end
end 
