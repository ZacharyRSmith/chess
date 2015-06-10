require './lib/chess/pieces/piece'
require './lib/chess/pieces/rook'
require './lib/chess/square'
require './lib/chess/board'
require 'minitest/autorun'

def gen_rook(coordinates: [0, 0], owner: " ")
  brd = Board.new()
  brd.clear_off_pieces()
  sqr = brd.get_square(coordinates[0], coordinates[1])
  Rook.new(square: sqr, owner: owner)
end


class TestRook < MiniTest::Test
  def test_icon
    rook = gen_rook()
    assert_equal("R", rook.icon)
  end

  def test_owner_with_comma
    rook = gen_rook(owner: ",")
    assert_equal(",", rook.owner)
  end

  def test_owner_with_blank
    rook = gen_rook(owner: " ")
    assert_equal(" ", rook.owner)
  end

 def test_moves_limited_if_need_to_block_check
    board = Board.new()
    
    # Remove pawn so enemy bishop can attack king
    sqr_d2 = board.get_square('d2')
    sqr_d2.piece = nil
    
    sqr = board.get_square('c3')
    sqr.piece = Bishop.new(owner: ",", square: sqr)
    
    sqr = board.get_square('d1')
    rook = Rook.new(owner: " ", square: sqr)
    sqr.piece = rook
    rook.set_los()
    
    assert_equal([sqr_d2], rook.los)
  end
end
