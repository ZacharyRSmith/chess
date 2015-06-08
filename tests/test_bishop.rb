require './lib/chess/pieces/bishop'
require './lib/chess/square'
require './lib/chess/board'
require 'minitest/autorun'

def gen_bishop(coordinates: [0, 0], owner: ",")
  brd = Board.new()
  sqr = Square.new(board: brd, coordinates: coordinates)
  Bishop.new(square: sqr, owner: owner)
end

class TestBishop < MiniTest::Test

  def test_icon
    bishop = gen_bishop()
    assert_equal("A", bishop.icon)
  end

  def test_owner_with_comma
    bishop = gen_bishop(owner: ",")
    assert_equal(",", bishop.owner)
  end

  def test_owner_with_blank
    bishop = gen_bishop(owner: " ")
    assert_equal(" ", bishop.owner)
  end

  def test_set_los_with_blank_board
    bishop = gen_bishop(coordinates: [1,1])
    bishop.set_los()
    actual_coords = []
    bishop.los.each { |sqr| actual_coords << sqr.coordinates }

    expected_coords = [[0,0], [3,3], [0,2], [2,0], [2,2], [4,4], [5,5], [6,6], [7,7]]
    actual_coords.sort!
    expected_coords.sort!

    assert_equal(expected_coords, actual_coords)
  end
end