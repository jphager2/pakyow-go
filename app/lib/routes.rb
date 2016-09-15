Pakyow::App.routes do

  default '/' do
    @pgame ||= current_game

    view.scope(:game).mutate(:show, with: @pgame).subscribe
  end

  get :login, '/login' do
    reroute router.group(:session).path(:new), :get
  end

  get :logout, '/logout' do
    reroute router.group(:session).path(:remove), :delete
  end
end
