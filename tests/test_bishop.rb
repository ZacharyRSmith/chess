require './lib/chess/pieces/bishop'
require './lib/chess/square'
require './lib/chess/board'
require 'minitest/autorun'

def gen_bishop(coordinates: [0, 0], owner: ",")
  brd = Board.new()
  sqr = Square.new(board: brd, coordinates: coordinates)
  Bishop.new(square: sqr, owner: owner)
end

class TestBishop < Minitest::Test

  def test_icon
    bishop = gen_bishop()
    assert_equal("B", bishop.icon)
  end

  def test_owner_with_comma
    bishop = gen_bishop(owner: ",")
    assert_equal(",", bishop.owner)
  end

  def test_owner_with_blank
    bishop = gen_bishop(owner: " ")
    assert_equal(" ", bishop.owner)
  end

  def test_set_los
  end
end