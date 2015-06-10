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
  
  def test_white_castle_king_side_with_success
    board = Board.new()
    king  = board.white_king
    rook  = board.get_square('h1').piece
    
    # Clear squares for castling
    sqr_f1 = board.get_square('f1')
    sqr_f1.piece = nil
    sqr_g1 = board.get_square('g1')
    sqr_g1.piece = nil
    king.set_los()
    
    assert(king.los.include?(sqr_g1))
    assert(board.move_is_castling?(king, sqr_g1))
    
    board.castle(king, sqr_g1)
    
    refute(board.get_square('e1').piece)
    assert(sqr_g1.piece && sqr_g1.piece == king)
    refute(board.get_square('h1').piece)
    assert(sqr_f1.piece && sqr_f1.piece == rook)
  end
  
  def test_black_castle_king_side_with_success
    board = Board.new()
    king  = board.black_king
    rook  = board.get_square('h8').piece
    
    # Clear squares for castling
    sqr_f8 = board.get_square('f8')
    sqr_f8.piece = nil
    sqr_g8 = board.get_square('g8')
    sqr_g8.piece = nil
    king.set_los()
    
    assert(king.los.include?(sqr_g8))
    assert(board.move_is_castling?(king, sqr_g8))
    
    board.castle(king, sqr_g8)
    
    refute(board.get_square('e8').piece)
    assert(sqr_g8.piece && sqr_g8.piece == king)
    refute(board.get_square('h8').piece)
    assert(sqr_f8.piece && sqr_f8.piece == rook)
  end
  
  def test_white_castle_queen_side_with_success
    board = Board.new()
    king  = board.white_king
    rook  = board.get_square('a1').piece
    
    # Clear squares for castling
    sqr_d1 = board.get_square('d1')
    sqr_d1.piece = nil
    sqr_c1 = board.get_square('c1')
    sqr_c1.piece = nil
    sqr_b1 = board.get_square('b1')
    sqr_b1.piece = nil
    king.set_los()
    
    assert(king.los.include?(sqr_c1))
    assert(board.move_is_castling?(king, sqr_c1))
    
    board.castle(king, sqr_c1)
    
    refute(board.get_square('e1').piece)
    assert(sqr_c1.piece && sqr_c1.piece == king)
    refute(board.get_square('a1').piece)
    assert(sqr_d1.piece && sqr_d1.piece == rook)
  end
  
  def test_black_castle_queen_side_with_success
    board = Board.new()
    king  = board.black_king
    rook  = board.get_square('a8').piece
    
    # Clear squares for castling
    sqr_d8 = board.get_square('d8')
    sqr_d8.piece = nil
    sqr_c8 = board.get_square('c8')
    sqr_c8.piece = nil
    sqr_b8 = board.get_square('b8')
    sqr_b8.piece = nil
    king.set_los()
    
    assert(king.los.include?(sqr_c8))
    assert(board.move_is_castling?(king, sqr_c8))
    
    board.castle(king, sqr_c8)
    
    refute(board.get_square('e8').piece)
    assert(sqr_c8.piece && sqr_c8.piece == king)
    refute(board.get_square('a8').piece)
    assert(sqr_d8.piece && sqr_d8.piece == rook)
  end
  
  def test_white_cannot_castle_king_side_if_rook_moved
    board = Board.new()
    king  = board.white_king
    rook  = board.get_square('h1').piece
    
    # Clear squares for castling
    sqr_f1 = board.get_square('f1')
    sqr_f1.piece = nil
    sqr_g1 = board.get_square('g1')
    sqr_g1.piece = nil
    
    rook.moved = true
    king.set_los()
    
    refute(king.los.include?(sqr_g1))
    
    rook.moved = false
    king.set_los()
    
    assert(king.los.include?(sqr_g1))
  end
  
  def test_white_cannot_castle_king_side_if_king_moved
    board = Board.new()
    king  = board.white_king
    
    # Clear squares for castling
    sqr_f1 = board.get_square('f1')
    sqr_f1.piece = nil
    sqr_g1 = board.get_square('g1')
    sqr_g1.piece = nil
    
    king.moved = true
    king.set_los()
    
    refute(king.los.include?(sqr_g1))
    
    king.moved = false
    king.set_los()
    
    assert(king.los.include?(sqr_g1))
  end
  
  def test_cannot_castle_king_side_if_king_is_checked
    board = Board.new()
    king  = board.white_king
    rook  = board.get_square('h1').piece
    
    # Clear squares for castling
    sqr_f1 = board.get_square('f1')
    sqr_f1.piece = nil
    sqr_g1 = board.get_square('g1')
    sqr_g1.piece = nil
    
    # Replace pawn with Queen to check King
    sqr_d2 = board.get_square('d2')
    sqr_d2.piece = Queen.new(owner: ",", square: sqr_d2)

    king.set_los()
    
    refute(king.los.include?(sqr_g1))
    
    sqr_d2.piece = nil
    king.set_los()
    
    assert(king.los.include?(sqr_g1))
  end
  
  def test_cannot_castle_king_side_if_kings_intermediary_sqr_is_checked
    board = Board.new()
    king  = board.white_king
    rook  = board.get_square('h1').piece
    
    # Clear squares for castling
    sqr_f1 = board.get_square('f1')
    sqr_f1.piece = nil
    sqr_g1 = board.get_square('g1')
    sqr_g1.piece = nil
    
    # Remove pawn and place Queen to check King
    board.get_square('f2').piece = nil
    sqr_f3 = board.get_square('f3')
    sqr_f3.piece = Queen.new(owner: ",", square: sqr_f3)

    king.set_los()
    
    refute(king.los.include?(sqr_g1))
    
    sqr_f3.piece = nil
    king.set_los()
    
    assert(king.los.include?(sqr_g1))
  end
  
  def test_cannot_castle_king_side_if_kings_final_sqr_is_checked
    board = Board.new()
    king  = board.white_king
    rook  = board.get_square('h1').piece
    
    # Clear squares for castling
    sqr_f1 = board.get_square('f1')
    sqr_f1.piece = nil
    sqr_g1 = board.get_square('g1')
    sqr_g1.piece = nil
    
    # Remove pawn and place Queen to check King
    board.get_square('g2').piece = nil
    sqr_g3 = board.get_square('g3')
    sqr_g3.piece = Queen.new(owner: ",", square: sqr_g3)

    king.set_los()
    
    refute(king.los.include?(sqr_g1))
    
    sqr_g3.piece = nil
    king.set_los()
    
    assert(king.los.include?(sqr_g1))
  end
end
