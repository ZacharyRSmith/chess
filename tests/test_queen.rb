require './lib/chess/pieces/piece'
require './lib/chess/pieces/queen'
require './lib/chess/square'
require './lib/chess/board'
require 'minitest/autorun'

def gen_queen(coordinates: [0, 0], owner: " ")
  brd = Board.new()
  brd.clear_off_pieces()
  sqr = brd.get_square(coordinates[0], coordinates[1])
  Queen.new(square: sqr, owner: owner)
end


class TestQueen < MiniTest::Test
  def test_icon
    queen = gen_queen()
    assert_equal("Q", queen.icon)
  end

  def test_owner_with_comma
    queen = gen_queen(owner: ",")
    assert_equal(",", queen.owner)
  end

  def test_owner_with_blank
    queen = gen_queen(owner: " ")
    assert_equal(" ", queen.owner)
  end

  def test_moves_limited_if_need_to_block_check
    board = Board.new()
    
    # Remove pawn so enemy bishop can attack king
    sqr_d2 = board.get_square('d2')
    sqr_d2.piece = nil
    
    sqr = board.get_square('c3')
    sqr.piece = Bishop.new(owner: ",", square: sqr)
    
    queen = board.get_square('d1').piece
    queen.set_los()
    
    assert_equal([sqr_d2], queen.los)
  end
end
