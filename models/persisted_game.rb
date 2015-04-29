class PersistedGame < ActiveRecord::Base

  def to_game
    game  = Game.new(board: 9)
    game.board.board = get_board
    game.instance_variable_set(:@moves, get_moves)
    game
  end

  def turn
    black_turn ? :black : :white
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
end
