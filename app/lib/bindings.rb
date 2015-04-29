Pakyow::App.bindings do
  # define bindings here

  scope :game do
    binding :new do
      { href: router.path(:new) }
    end
  end

  scope :column do
    binding :play do
      { href: router.path(:play, x: bindable[:x], y: bindable[:y]) }
    end
    binding :stone do
      { class: ->(klass) { klass << bindable[:stone] } }
    end
  end
end
