require './lib/chess/pieces/bishop'
require './lib/chess/pieces/piece'
require './lib/chess/square'
require './lib/chess/board'
require 'minitest/autorun'
require_relative '_test_helpers'

def gen_bishop(coordinates: [0, 0], owner: ",")
  brd = Board.new()
  brd.clear_off_pieces()
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

    assert_empty(bishop.los)
    refute(bishop.can_move)
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

    assert_equal_after_sorting(expected_coords, actual_coords)
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
    
    assert_empty(bishop.los)
  end

  def test_cannot_move_if_pinned
    board = Board.new()
    sqr = board.get_square(4, 1)
    bishop = Bishop.new(owner: " ", square: sqr)
    sqr.piece = bishop

    # This enemy rook would check king if bishop moved
    sqr = board.get_square(4, 2)
    sqr.piece = Rook.new(owner: ",", square: sqr)

    bishop.set_los()
    
    refute(bishop.can_move)
  end
  
  def test_moves_are_limited_if_needs_to_maintain_check_block
    board = Board.new()
    sqr = board.get_square('f2')
    bishop = Bishop.new(owner: " ", square: sqr)
    sqr.piece = bishop

    # This enemy queen would check king if bishop moved other than g3/h4
    sqr = board.get_square('h4')
    sqr.piece = Queen.new(owner: ",", square: sqr)

    bishop.set_los()
    actual_sqrs = []
    
    bishop.los.each do |sqr|
      actual_sqrs << sqr.get_notation()
    end
    
    expected_sqrs = ['g3', 'h4']

    assert(bishop.can_move)
    assert_equal_after_sorting(expected_sqrs, actual_sqrs)
  end
end
