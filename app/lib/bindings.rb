Pakyow::App.bindings do
  # define bindings here
  
  scope :user_game do
    binding :sgf do
      { content: bindable.to_game.to_sgf }
    end
    binding :show do
      { href: router.group(:game).path(:show, game_id: bindable.id) }
    end
    binding :name do
      { content: bindable.name }
    end
    binding :updated_at do
      { content: bindable.updated_at.strftime('%H:%M, %d %^b %Y') }
    end
    binding :download do
      {href: router.group(:game).path(:download, game_id: bindable.id)}
    end
    binding :email do
      { href: router.group(:game).path(:email, game_id: bindable.id) }
    end
  end

  scope :game do
    binding :board_size do
      range = case bindable[:pgame].board_size
              when (0..9)   then 'size-9'
              when (10..13) then 'size-13'
              when (14..19) then 'size-19'
              else 'all_bets_off'
              end
      { class: ->(klass) { klass << range } }
    end
    binding :new do
      { 
        href: router.group(:game).path(:new),
        content: 'Start a new game'
      }
    end
    binding :new_9 do
      part :href do
        path = router.group(:game).path(:new) 
        Addressable::URI.new(path: path, query_values: { size: 9 })
      end
      part(:content) { "(9)" }
    end
    binding :new_13 do
      part :href do
        path = router.group(:game).path(:new) 
        Addressable::URI.new(path: path, query_values: { size: 13 })
      end
      part(:content) { '(13)' }
    end
    binding :new_19 do
      part :href do
        path = router.group(:game).path(:new) 
        Addressable::URI.new(path: path, query_values: { size: 19 })
      end
      part(:content) { '(19)' }
    end
    binding :pass do
      { 
        href: router.group(:game)
          .path(:pass, game_id: bindable[:pgame].id),
        content: 'Pass'
      }
    end
    binding :undo do
      { 
        href: router.group(:game)
          .path(:undo, game_id: bindable[:pgame].id),
        content: 'Undo'
      }
    end
    binding :download do
      { 
        href: router.group(:game)
          .path(:download, game_id: bindable[:pgame].id),
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
    binding :profile do
      user = current_or_guest_user
      { 
        href: router.group(:user).path(:show, user_id: user.id),
        content: "Back to Profile (#{user.name})"
      }
    end
  end

  scope :column do
    binding :play do
      part :action do
        router.group(:game).path(
          :play, 
          x: bindable[:x], 
          y: bindable[:y], 
          game_id: bindable[:pgame_id])
      end
    end
    binding :stone do
      part :class do |klass|
        klass.set(["stone", bindable[:stone]])
      end
    end
  end

  scope :email_game do
    binding :action do
      {
        action: router.group(:game)
          .path(:send_email, game_id: bindable.id),
        method: :post
      }
    end
  end

  scope :black do
    binding :turn do
      part :class do |klass|
        if bindable[:turn]
          klass.ensure("turn")
        else
          klass.deny("turn")
        end
      end
    end
  end

  scope :white do
    binding :turn do
      part :class do |klass|
        if bindable[:turn]
          klass.ensure("turn")
        else
          klass.deny("turn")
        end
      end
    end
  end
end
