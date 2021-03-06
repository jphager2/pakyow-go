Pakyow::App.resource :session, '/sessions' do
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
      if current_guest_user
        user.take_ownership(current_guest_user.persisted_games)
        current_guest_user.destroy
        session[:guest_user] = nil
      end
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

