Pakyow::App.bindings do
  # define bindings here
  
  scope :user do
    restful :user
  end

  scope :session do
    restful :session
  end

  scope :user_game do
    binding :link do
      { href: router.group(:game).path(:show, game_id: bindable.id) }
    end

    binding :name do
      { content: bindable.name }
    end

    binding :updated_at do
      { content: bindable.updated_at.strftime('%H:%M, %d %^b %Y') }
    end
  end

  scope :game do
    binding :new do
      { 
        href: router.group(:game).path(:new),
        content: 'Start a new game'
      }
    end
    binding :pass do
      { 
        href: router.group(:game).path(:pass),
        content: 'Pass'
      }
    end
    binding :undo do
      { 
        href: router.group(:game).path(:undo),
        content: 'Undo'
      }
    end
    binding :download do
      { 
        href: router.group(:game).path(:download),
        content: 'Download (SGF)' 
      }
    end
    binding :login_logout do
      if current_user?
        { 
          href: router.path(:logout),
          content: 'Logout' 
        }
      else
        { 
          href: router.path(:login),
          content: 'Login' 
        }
      end
    end
    binding :profile do
      user = current_or_guest_user
      { 
        href: router.group(:user).path(:show, user_id: user.id),
        content: "Profile (#{user.name})"
      }
    end
  end

  scope :link do
    binding :signup do
      { 
        href: router.group(:user).path(:new),
        content: 'Signup!' 
      }
    end
  end

  scope :column do
    binding :play do
      { 
        href: router.group(:game)
          .path(:play, x: bindable[:x], y: bindable[:y]) 
      }
    end
    binding :stone do
      { class: ->(klass) { klass << bindable[:stone] } }
    end
  end
end
