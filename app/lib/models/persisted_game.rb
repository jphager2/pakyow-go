class PersistedGame < ActiveRecord::Base

  belongs_to :user
  before_save :set_board_size

  def name
    "#{user.name} Game #{id}"
  end

  def board_data
    { 
      rows: get_board.map.with_index { |row, x| 
        { columns: row.map.with_index { |col, y| 
          { stone: col.color, x: x, y: y, pgame_id: id } 
        }} 
      }
    }
  end

  def update_game(game, played = false)
    set_board(game.board)
    set_moves(game.instance_variable_get(:@moves))
    set_next_turn if played
    save
  end

  def to_game
    game  = Game.new(board: board_size)
    game.board.board = get_board
    game.instance_variable_set(:@moves, get_moves)
    game
  end

  def turn
    black_turn ? :black : :white
  end

  def white_turn?
    !black_turn
  end

  def black_turn?
    black_turn
  end

  def set_next_turn
    self.black_turn = !self.black_turn
  end

  def set_board(board_data)
    if board_data.respond_to?(:board)
      set_board(board_data.board)
    else
      self.board = board_data.to_yaml
    end
  end

  def get_board
    YAML.load(board)
  end

  def set_moves(moves_data)
    self.moves = moves_data.to_yaml
  end

  def get_moves
    YAML.load(moves)
  end

  def set_board_size
    if !board_size && board.present?
      self.board_size = get_board.length
    end
  end
end
