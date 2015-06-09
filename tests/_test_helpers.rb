def set_up_default_board
  board = Board.new()
  board.set_up_pawns()
  board.set_up_back_rows()

  board
end
