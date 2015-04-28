Pakyow::App.bindings do
  # define bindings here

  scope :column do
    binding :stone do
      { class: ->(klass) { klass << bindable[:stone] } }
    end
  end
end
