Pakyow::App.bindings do
  # define bindings here
  
  scope :user do
    restful :user
  end

  scope :session do
    restful :session
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
