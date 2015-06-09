require_relative '_test_helpers'
require './lib/chess/pieces/king'
require './lib/chess/pieces/piece'
require './lib/chess/square'
require './lib/chess/board'
require 'minitest/autorun'


class TestKing < MiniTest::Test
  def test_icon
    board = Board.new()
    king = board.get_square(4, 0).piece

    assert_equal("K", king.icon)
  end

  def test_owner_with_white_piece
    board = Board.new()
    king = board.white_king

    assert_equal(" ", king.owner)
  end

  def test_owner_with_black_piece
    board = Board.new()
    king = board.black_king

    assert_equal(",", king.owner)
  end

  def test_cannot_move_when_blocked_by_friendly_pieces
    board = Board.new()

    refute(board.white_king.can_move)
  end

  def test_can_move_when_blocked_by_enemy_pieces
    board = Board.new()
    king = board.white_king
    sqr = board.get_square(4, 1)
    sqr.piece = Piece.new(owner: ",", square: sqr)
    king.set_los()

    assert(king.can_move)
  end
end