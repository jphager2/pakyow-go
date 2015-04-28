Pakyow::App.routes do
  # define your routes here

  # see something working by uncommenting the line below
  # default do
  #   puts 'hello'
  # end

  get '/' do
=begin
    data = {
      playing_white: 'jphager2',
      playing_black: 'moax',
      rows: [
        { columns: [ 
          { stone: :black }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
        ]},
        { columns: [ 
          { stone: :black }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
        ]},
        { columns: [ 
          { stone: :black }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
        ]},
        { columns: [ 
          { stone: nil }, 
          { stone: nil }, 
          { stone: :black }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: :black }, 
        ]},
        { columns: [ 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: :black }, 
          { stone: nil }, 
          { stone: :white }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
        ]},
        { columns: [ 
          { stone: nil }, 
          { stone: nil }, 
          { stone: :black }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: :white }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
        ]},
        { columns: [ 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: :black }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
        ]},
        { columns: [ 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: :black }, 
          { stone: nil }, 
        ]},
        { columns: [ 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: :black }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
          { stone: nil }, 
        ]},
      ]
    }
=end
    game = Game.new(board: 9)
    game.black(2,2)
    game.white(6,6)
    game.black(3,5)
    data = data_from_board(game.board.board)

    view.scope(:board).apply(data) do |rws, board_data|
      rws.scope(:row).apply(board_data[:rows]) do |cls, row_data|
        cls.scope(:column).apply(row_data[:columns])
      end
    end
  end
end
