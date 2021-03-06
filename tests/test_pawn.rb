require './lib/chess/pieces/pawn'
require './lib/chess/pieces/piece'
require './lib/chess/square'
require './lib/chess/board'
require 'minitest/autorun'

def gen_pawn(coordinates: [0,1], owner: " ")
  brd = Board.new()
  sqr = brd.get_square(coordinates[0], coordinates[1])
  pawn = Pawn.new(square: sqr, owner: owner)
  pawn.set_los()
  pawn
end


class TestPawn < MiniTest::Test

  def test_icon
    pawn = gen_pawn()
    assert_equal("p", pawn.icon)
  end

  def test_owner_with_comma
    pawn = gen_pawn(owner: ",")
    assert_equal(",", pawn.owner)
    assert_equal(-1,   pawn.direction)
  end

  def test_owner_with_blank
    pawn = gen_pawn(owner: " ")
    assert_equal(" ", pawn.owner)
    assert_equal(1,  pawn.direction)
  end

  def test_pawn_cannot_move_with_piece_right_in_front
    pawn = gen_pawn(coordinates: [0,1])
    brd = pawn.board
    sqr = brd.get_square(0,2)
    sqr.piece = Piece.new(square: sqr)
    pawn.set_los()

    refute(pawn.can_move)
  end

  def test_pawn_can_move_with_no_piece_right_in_front
    pawn = gen_pawn()
    pawn.set_los()

    assert(pawn.can_move)
  end

  def test_unmoved_pawn_can_move_two
    board = Board.new()
    pawn = board.get_square('e2').piece
    sqr_two_in_front = board.get_square('e4')

    assert(pawn.los.include?(sqr_two_in_front))
  end

  def test_moved_pawn_cannot_move_two
    pawn = gen_pawn(coordinates: [0, 1])

    pawn.moved = TRUE
    pawn.set_los()

    coords = []
    pawn.los.each do |sqr|
      coords << sqr.coordinates
    end

    refute_includes(coords, [0, 3])
  end

  def test_can_attack_enemy
    board = Board.new()
    
    sqr = board.get_square('d3')
    sqr.piece = Queen.new(owner: ",", square: sqr)

    pawn = board.get_square('e2').piece
    pawn.set_los()
    
    assert(pawn.los.include?(sqr))
  end

  def test_cannot_attack_friend
    board = Board.new()
    
    sqr = board.get_square('d3')
    sqr.piece = Queen.new(owner: " ", square: sqr)

    pawn = board.get_square('e2').piece
    pawn.set_los()
    
    refute(pawn.los.include?(sqr))
  end
  
  def test_moves_limited_if_need_to_block_check
    board = Board.new()

    # Remove pawn so queen can attack king
    sqr_f2 = board.get_square('f2')
    sqr_f2.piece = nil
    
    sqr = board.get_square('h4')
    sqr.piece = Queen.new(owner: ",", square: sqr)
    
    pawn = board.get_square('g2').piece
    pawn.set_los()
    
    assert_equal([board.get_square('g3')], pawn.los)
  end
end
