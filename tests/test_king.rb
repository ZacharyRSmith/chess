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

  def test_is_not_checked_at_start
    board = Board.new()
    
    refute(board.white_king.is_checked?)
  end

  def test_is_checked_by_enemy_bishop
    board = Board.new()

    # Remove pawn so bishop can attack white king
    board.get_square(3, 1).piece = nil

    sqr = board.get_square(0, 4)
    sqr.piece = Bishop.new(owner: ",", square: sqr)

    assert(board.white_king.is_checked?)
  end
  
  def test_is_not_checked_by_friendly_bishop
    board = Board.new()

    # Remove pawn so bishop can attack white king
    board.get_square(3, 1).piece = nil

    sqr = board.get_square(0, 4)
    sqr.piece = Bishop.new(owner: " ", square: sqr)

    refute(board.white_king.is_checked?)
  end
  
  def test_is_checked_by_enemy_king?
    board = Board.new()
    
    # Remove pawn so king can attack white king
    sqr_in_front = board.get_square(4, 1)
    sqr_in_front.piece = nil
    sqr_in_front.piece = King.new(owner: ",", square: sqr_in_front)

    assert(board.white_king.is_checked?)
  end

  def test_is_checked_by_enemy_knight?
    board = Board.new()

    sqr = board.get_square(3, 2)
    sqr.piece = Knight.new(owner: ",", square: sqr)

    assert(board.white_king.is_checked?)
  end
  
  def test_is_not_checked_by_friendly_knight?
    board = Board.new()

    sqr = board.get_square(3, 2)
    sqr.piece = Knight.new(owner: " ", square: sqr)

    refute(board.white_king.is_checked?)
  end

  def test_is_checked_by_enemy_pawn?
    board = Board.new()
    sqr = board.get_square(3, 1)
    sqr.piece = Pawn.new(owner: ",", square: sqr)

    assert(board.white_king.is_checked?)
  end
  
  def test_is_not_checked_by_friendly_pawn?
    board = Board.new()
    king = board.white_king

    orig_sqr = king.square
    # This places the king in the attack position of two of its own pawns
    new_sqr = board.get_square(4, 2)
    orig_sqr.piece = nil
    king.square = new_sqr
    
    refute(king.is_checked?)
  end

  def test_is_checked_by_enemy_queen_from_diag?
    board = Board.new()

    # Remove pawn so queen can attack white king
    board.get_square(3, 1).piece = nil

    sqr = board.get_square(0, 4)
    sqr.piece = Queen.new(owner: ",", square: sqr)

    assert(board.white_king.is_checked?)
  end
  
  def test_is_not_checked_by_friendly_queen_from_diag?
    board = Board.new()

    # Remove pawn so queen can attack white king
    board.get_square(3, 1).piece = nil

    sqr = board.get_square(0, 4)
    sqr.piece = Queen.new(owner: " ", square: sqr)

    refute(board.white_king.is_checked?)
  end
  
  def test_is_checked_by_enemy_queen_orthogonally?
    board = Board.new()

    # Remove pawn so queen can attack white king
    board.get_square(4, 1).piece = nil

    sqr = board.get_square(4, 5)
    sqr.piece = Queen.new(owner: ",", square: sqr)

    assert(board.white_king.is_checked?)
  end
  
  def test_is_not_checked_by_friendly_queen_orthogonally?
    board = Board.new()

    # Remove pawn so queen can attack white king
    board.get_square(4, 1).piece = nil

    sqr = board.get_square(4, 5)
    sqr.piece = Queen.new(owner: " ", square: sqr)

    refute(board.white_king.is_checked?)
  end

  def test_is_checked_by_enemy_rook?
    board = Board.new()

    # Remove pawn so queen can attack white king
    board.get_square(4, 1).piece = nil

    sqr = board.get_square(4, 5)
    sqr.piece = Rook.new(owner: ",", square: sqr)

    assert(board.white_king.is_checked?)
  end
  
  def test_is_not_checked_by_friendly_rook?
    board = Board.new()

    # Remove pawn so queen can attack white king
    board.get_square(4, 1).piece = nil

    sqr = board.get_square(4, 5)
    sqr.piece = Rook.new(owner: " ", square: sqr)

    refute(board.white_king.is_checked?)
  end

  def test_cannot_move_into_check
    board = Board.new()
    
    # Remove pawn so queen can attack square in front of king
    board.get_square('e2').piece = nil
    
    sqr = board.get_square('h5')
    sqr.piece = Queen.new(owner: ",", square: sqr)
    
    king = board.white_king
    king.set_los()
    
    assert_empty(king.los)
  end
end
