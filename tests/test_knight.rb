require './lib/chess/pieces/knight'
require './lib/chess/pieces/piece'
require './lib/chess/square'
require './lib/chess/board'
require 'minitest/autorun'
require_relative '_test_helpers'


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
    knight = board.get_square('b1').piece
    actual_sqrs = []

    knight.los.each do |sqr|
      actual_sqrs << sqr.get_notation()
    end

    expected_sqrs = ['a3', 'c3']

    assert_equal_after_sorting(expected_sqrs, actual_sqrs)
  end

  def test_moves_limited_if_need_to_block_check
    board = Board.new()

    # Remove pawn so queen can attack king
    sqr_e2 = board.get_square('e2')
    sqr_e2.piece = nil
    
    sqr = board.get_square('e4')
    sqr.piece = Queen.new(owner: ",", square: sqr)
    
    knight = board.get_square('g1').piece
    knight.set_los()
    
    assert_equal([sqr_e2], knight.los)
  end
end
