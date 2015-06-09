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
end