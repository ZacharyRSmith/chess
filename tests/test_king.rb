require_relative '_test_helpers'
require './lib/chess/pieces/king'
require './lib/chess/pieces/piece'
require './lib/chess/square'
require './lib/chess/board'
require 'minitest/autorun'


class TestKing < MiniTest::Test
  def test_icon
    board = set_up_default_board()
    king = board.get_square(4, 0).piece

    assert_equal("K", king.icon)
  end

  def test_owner_with_white_piece
    board = set_up_default_board()
    king = board.get_square(4, 0).piece

    assert_equal(" ", king.owner)
  end

  def test_owner_with_black_piece
    board = set_up_default_board()
    king = board.get_square(4, 7).piece

    assert_equal(",", king.owner)
  end

  def test_cannot_move_when_blocked_by_friendly_pieces
    board = set_up_default_board()
    king = board.get_square(4, 0).piece

    refute(king.can_move)
  end

  def test_can_move_when_blocked_by_enemy_pieces
    board = set_up_default_board()
    king = board.get_square(4, 0).piece
    sqr = board.get_square(4, 1)
    sqr.piece = Piece.new(owner: ",", square: sqr)
    king.set_los()

    assert(king.can_move)
  end
end