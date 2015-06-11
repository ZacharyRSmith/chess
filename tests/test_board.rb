require './lib/chess/board'
require 'minitest/autorun'


class TestBoard < MiniTest::Test
  def test_get_castling_rook_hash
    board = Board.new()
    rook_hash = board.get_castling_rook_hash(board.get_square('g1'))
    
    assert_equal(board.get_square('h1').piece, rook_hash['rook'])
    assert_equal(board.get_square('f1'),       rook_hash['sqr'])
  end
  
  def test_white_king
    board = Board.new()
    assert(board.white_king.is_a? King)
    assert_equal([4,0], board.white_king.square.coordinates)
  end

  def test_black_king
    board = Board.new()
    assert(board.black_king.is_a? King)
    assert_equal([4,7], board.black_king.square.coordinates)
  end

  def test_empty_squares
    board = Board.new()

    2.upto(5) do |row|
      0.upto(7) do |col|
        refute(board.get_square(col, row).piece)
      end
    end
  end

  def test_presence_of_pawns
    board = Board.new()

    [1, 6].each do |row|
      (0..7).each do |col|
        sqr = board.get_square(col, row)
        assert_instance_of(Pawn, sqr.piece)
      end
    end
  end

  def test_presence_of_pieces_on_back_rows
    board = Board.new()

    [0, 7].each do |row|
      [0, 7].each do |col|
        sqr = board.get_square(col, row)
        assert_instance_of(Rook, sqr.piece)
      end

      [1, 6].each do |col|
        sqr = board.get_square(col, row)
        assert_instance_of(Knight, sqr.piece)
      end

      [2, 5].each do |col|
        sqr = board.get_square(col, row)
        assert_instance_of(Bishop, sqr.piece)
      end

      [3].each do |col|
        sqr = board.get_square(col, row)
        assert_instance_of(Queen, sqr.piece)
      end

      [4].each do |col|
        sqr = board.get_square(col, row)
        assert_instance_of(King, sqr.piece)
      end
    end
  end

  def test_los_of_rooks
    board = Board.new()

    # Bottom-left rook:
    rook = board.get_square(0, 0).piece
    actual_coords = []

    rook.set_los()
    rook.los.each do |sqr|
      actual_coords << sqr.coordinates
    end

    expected_coords = []

    assert_equal(expected_coords, actual_coords)

    # Top-right rook:
    rook = board.get_square(7, 7).piece
    actual_coords = []

    rook.set_los()
    rook.los.each do |sqr|
      actual_coords << sqr.coordinates
    end

    expected_coords = []

    assert_equal(expected_coords, actual_coords)

    # Top-left rook:
    rook = board.get_square(7, 0).piece
    actual_coords = []

    rook.los.each do |sqr|
      actual_coords << sqr.coordinates
    end

    expected_coords = []

    assert_equal(expected_coords, actual_coords)

    # Bottom-right rook
    rook = board.get_square(0, 7).piece
    actual_coords = []

    rook.los.each do |sqr|
      actual_coords << sqr.coordinates
    end

    expected_coords = []

    assert_equal(expected_coords, actual_coords)
  end

  def test_los_of_knights
    board = Board.new()

    # Top-right knight
    knight = board.get_square('g8').piece
    actual_sqrs = []

    knight.set_los()
    knight.los.each do |sqr|
      actual_sqrs << sqr.get_notation()
    end

    expected_sqrs = ['h6', 'f6']
    expected_sqrs.sort!
    actual_sqrs.sort!

    assert_equal(expected_sqrs, actual_sqrs)

    # Bottom-right knight
    knight = board.get_square('g1').piece
    actual_sqrs = []

    knight.set_los()
    knight.los.each do |sqr|
      actual_sqrs << sqr.get_notation()
    end

    expected_sqrs = ['h3', 'f3']
    expected_sqrs.sort!
    actual_sqrs.sort!

    assert_equal(expected_sqrs, actual_sqrs)

    # Bottom-left knight
    knight = board.get_square('b1').piece
    actual_sqrs = []

    knight.set_los()
    knight.los.each do |sqr|
      actual_sqrs << sqr.get_notation()
    end

    expected_sqrs = ['c3', 'a3']
    expected_sqrs.sort!
    actual_sqrs.sort!

    assert_equal(expected_sqrs, actual_sqrs)

    # Top-left knight
    knight = board.get_square('b8').piece
    actual_sqrs = []

    knight.set_los()
    knight.los.each do |sqr|
      actual_sqrs << sqr.get_notation()
    end

    expected_sqrs = ['c6', 'a6']
    expected_sqrs.sort!
    actual_sqrs.sort!

    assert_equal(expected_sqrs, actual_sqrs)
  end

  def test_los_of_bishop
    board = Board.new()
    
    # Top-left bishop
    bishop = board.get_square('c8').piece
    actual_sqrs = []

    bishop.set_los()
    bishop.los.each do |sqr|
      actual_sqrs << sqr.get_notation()
    end

    assert_empty(actual_sqrs)
  end

  def test_los_of_queen
    board = Board.new()
    
    # White queen
    queen = board.get_square('d1').piece
    actual_sqrs = []

    queen.set_los()
    queen.los.each do |sqr|
      actual_sqrs << sqr.get_notation()
    end

    assert_empty(actual_sqrs)
  end

  def test_los_of_king
    board = Board.new()
    board.white_king.set_los()

    assert_empty(board.white_king.los)
  end

  def test_los_of_pawn
    board = Board.new()

    pawn = board.get_square('a2').piece
    actual_sqrs = []

    pawn.set_los()
    pawn.los.each do |sqr|
      actual_sqrs << sqr.get_notation()
    end

    expected_sqrs = ['a3', 'a4']
    expected_sqrs.sort!
    actual_sqrs.sort!

    assert_equal(expected_sqrs, actual_sqrs)
  end

  def test_move_piece
    board = Board.new()
    
    old_sqr = board.get_square('e2')
    kings_pawn = old_sqr.piece
    new_sqr = board.get_square('e3')
    board.move_piece(kings_pawn, new_sqr)
    
    refute(old_sqr.piece)
    assert(new_sqr.piece)
  end
  
  def test_is_checkmated
    board = Board.new()

    # Remove pawns so Queen can checkmate
    board.get_square('f2').piece = nil
    board.get_square('g2').piece = nil
    
    sqr = board.get_square('h4')
    sqr.piece = Queen.new(owner: ",", square: sqr)

    assert(board.white_king.is_checked?)
    assert(!board.can_uncheck?(" "))
  end
  
  def test_is_not_checkmated_if_pawn_can_block
    board = Board.new()

    # Remove pawn so Queen can check
    board.get_square('f2').piece = nil
    
    sqr = board.get_square('h4')
    sqr.piece = Queen.new(owner: ",", square: sqr)
    
    # Pawn at 'g2' should be able to uncheck
    assert(board.white_king.is_checked?)
    refute(!board.can_uncheck?(" "))
  end

  def test_move_promotes_pawn?
    board = Board.new()
    sqr = board.get_square('e7')
    pawn = Pawn.new(owner: " ", square: sqr)
    sqr.piece = pawn
    target_sqr = board.get_square('d8')
    
    assert(board.move_promotes_pawn?(pawn, target_sqr))
  end

  def test_end_game_conditions_with_fools_mate
    board = Board.new()
    
    # White's 1st move
    pawn = board.get_square('f2').piece
    board.move_piece(pawn, board.get_square('f3'))
    
    # Black's 1st move
    pawn = board.get_square('e7').piece
    board.move_piece(pawn, board.get_square('e5'))
    
    # White's 2nd move
    pawn = board.get_square('g2').piece
    board.move_piece(pawn, board.get_square('g4'))
    
    # Black's 2nd move
    queen = board.get_square('d8').piece
    board.move_piece(queen, board.get_square('h4'))
    
    assert(board.is_checked?(" "))
    refute(board.can_uncheck?(" "))
  end
  
  def test_can_move_true_at_start
    board = Board.new()
    
    assert(board.can_move?(" "))
    assert(board.can_move?(","))
  end
  
  def test_can_move_false_if_stuck
    board = Board.new()
    board.clear_off_pieces()
    
    sqr = board.get_square('a1')
    sqr.piece = King.new(owner: " ", square: sqr)
    board.white_king = sqr.piece
    
    sqr = board.get_square('b2')
    sqr.piece = Pawn.new(owner: " ", square: sqr)
    
    # This bishop pins white's pawn
    sqr = board.get_square('d4')
    sqr.piece = Bishop.new(owner: ",", square: sqr)
    
    # This bishop prevents King from moving to a2
    sqr = board.get_square('b3')
    sqr.piece = Bishop.new(owner: ",", square: sqr)
    
    # This bishop prevents King from moving to b1
    sqr = board.get_square('c2')
    sqr.piece = Bishop.new(owner: ",", square: sqr)

    refute(board.can_move?(" "))
  end
  
  def test_get_en_passant_moves
    board = Board.new()
    sneaker = board.get_square('e2').piece

    sqr = board.get_square('d4')
    pawn = Pawn.new(owner: ",", square: sqr)
    sqr.piece = pawn
    
    ep_moves = board.get_en_passant_moves(sneaker, board.get_square('e4'))
    
    assert(ep_moves[0][0] == pawn)
    assert(ep_moves[0][1] == board.get_square('e3'))
  end
  
  def test_get_en_passant_moves_with_two_moves
    board = Board.new()
    sneaker = board.get_square('e2').piece

    sqr = board.get_square('d4')
    pawn_d = Pawn.new(owner: ",", square: sqr)
    sqr.piece = pawn_d

    sqr = board.get_square('f4')
    pawn_f = Pawn.new(owner: ",", square: sqr)
    sqr.piece = pawn_f
    
    ep_moves = board.get_en_passant_moves(sneaker, board.get_square('e4'))
    
    assert(ep_moves[0][0] == pawn_d)
    assert(ep_moves[0][1] == board.get_square('e3'))
    
    assert(ep_moves[1][0] == pawn_f)
    assert(ep_moves[1][1] == board.get_square('e3'))
  end
end
