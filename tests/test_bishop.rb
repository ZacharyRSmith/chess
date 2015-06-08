require './lib/chess/pieces/bishop'
require './lib/chess/pieces/piece'
require './lib/chess/square'
require './lib/chess/board'
require 'minitest/autorun'

def gen_bishop(coordinates: [0, 0], owner: ",")
  brd = Board.new()
  sqr = brd.get_square(coordinates[0], coordinates[1])
  Bishop.new(square: sqr, owner: owner)
end


class TestBishop < MiniTest::Test

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

  def test_set_los_where_can_move_should_be_false
    bishop = gen_bishop(coordinates: [0,0], owner: " ")
    board = bishop.board
    sqr = board.get_square(1,1)
    sqr.piece = Piece.new(owner: " ", square: sqr)

    bishop.set_los()
    actual_coords = []
    bishop.los.each { |sqr| actual_coords << sqr.coordinates }

    expected_coords = [[1,1]]

    assert_equal(expected_coords, actual_coords)
    assert_equal(FALSE, bishop.can_move)
  end

  def test_set_los_where_can_move_should_be_true
    bishop = gen_bishop(coordinates: [0,0], owner: " ")
    board = bishop.board
    sqr = board.get_square(1,1)
    sqr.piece = Piece.new(owner: ",", square: sqr)

    bishop.set_los()
    actual_coords = []
    bishop.los.each { |sqr| actual_coords << sqr.coordinates }

    expected_coords = [[1,1]]

    assert_equal(expected_coords, actual_coords)
    assert_equal(TRUE, bishop.can_move)
  end

  def test_set_los_with_blank_board
    bishop = gen_bishop(coordinates: [1,1])

    bishop.set_los()
    actual_coords = []
    bishop.los.each { |sqr| actual_coords << sqr.coordinates }

    expected_coords = [[0,0], # Bottom-left diagonal
                       [2,2], [3,3], [4,4], [5,5], [6,6], [7,7], # Top-right
                       [0,2], # Top-left diagonal
                       [2,0]] # Bottom-right
    actual_coords.sort!
    expected_coords.sort!

    assert_equal(expected_coords, actual_coords)
  end

  def test_set_los_with_pieces_blocking_bishop
    bishop = gen_bishop(coordinates: [3,3], owner: " ")
    board = bishop.board

    # Top-right diagonal
    sqr = board.get_square(4,4)
    sqr.piece = Piece.new(owner: " ", square: sqr)

    # Bottom-right diagonal
    sqr = board.get_square(4,2)
    sqr.piece = Piece.new(owner: " ", square: sqr)

    # Bottom-left diagonal
    sqr = board.get_square(2,2)
    sqr.piece = Piece.new(owner: " ", square: sqr)

    # Top-left diagonal
    sqr = board.get_square(2,4)
    sqr.piece = Piece.new(owner: " ", square: sqr)

    bishop.set_los()
    actual_coords = []
    bishop.los.each { |sqr| actual_coords << sqr.coordinates }

    expected_coords = [[4,4], [4,2], [2,2], [2,4]]
    actual_coords.sort!
    expected_coords.sort!

    assert_equal(expected_coords, actual_coords)
  end
end