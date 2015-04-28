module Pakyow::Helpers
  # define methods here that are available from routes, bindings, etc

  def data_from_board(board)
    { 
      rows: board.map { |row| 
        { columns: row.map { |col| { stone: col.color } } } 
      } 
    }
  end
end
