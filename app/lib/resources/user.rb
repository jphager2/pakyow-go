Pakyow::App.resource :user, '/users' do
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
