require './lib/chess/pieces/knight'
require './lib/chess/pieces/piece'
require './lib/chess/square'
require './lib/chess/board'
require 'minitest/autorun'


class TestKnight < MiniTest::Test
  def test_icon
    board = Board.new()
    knight = board.get_square(1, 0).piece

    assert_equal("N", knight.icon)
  end

  def test_owner_with_comma
    board = Board.new()
    knight = board.get_square(1, 0).piece

    assert_equal(" ", knight.owner)
  end

  def test_owner_with_blank
    board = Board.new()
    knight = board.get_square(1, 7).piece

    assert_equal(",", knight.owner)
  end

  def test_los_with_default_board
    board = Board.new()
    knight = board.get_square(1, 0).piece

    actual_los_coords = []
    knight.los.each do |sqr|
      actual_los_coords << sqr.coordinates
    end

    expected_los_coords = [[2,2], [0,2], [3,1]]

    actual_los_coords.sort!
    expected_los_coords.sort!

    assert_equal(expected_los_coords, actual_los_coords)
  end
end