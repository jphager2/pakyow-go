Pakyow::Mutators :persisted_game do
  mutator :present do |view, pgame|
    view.apply(pgame)
  end
end
