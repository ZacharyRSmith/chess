require './lib/chess/board'
require 'minitest/autorun'


class TestBoard < MiniTest::Test
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

    rook.los.each do |sqr|
      actual_coords << sqr.coordinates
    end

    expected_coords = [[0,1], [1,0]]
    expected_coords.sort!
    actual_coords.sort!

    assert_equal(expected_coords, actual_coords)

    # Top-right rook:
    rook = board.get_square(7, 7).piece
    actual_coords = []

    rook.los.each do |sqr|
      actual_coords << sqr.coordinates
    end

    expected_coords = [[6,7], [7,6]]
    expected_coords.sort!
    actual_coords.sort!

    assert_equal(expected_coords, actual_coords)

    # Top-left rook:
    rook = board.get_square(7, 0).piece
    actual_coords = []

    rook.los.each do |sqr|
      actual_coords << sqr.coordinates
    end

    expected_coords = [[6,0], [7,1]]
    expected_coords.sort!
    actual_coords.sort!

    assert_equal(expected_coords, actual_coords)

    # Bottom-right rook
    rook = board.get_square(0, 7).piece
    actual_coords = []

    rook.los.each do |sqr|
      actual_coords << sqr.coordinates
    end

    expected_coords = [[0,6], [1,7]]
    expected_coords.sort!
    actual_coords.sort!

    assert_equal(expected_coords, actual_coords)
  end

  def test_los_of_knights
    board = Board.new()

    # Top-right knight
    knight = board.get_square(6,7).piece
    actual_coords = []

    knight.los.each do |sqr|
      actual_coords << sqr.coordinates
    end

    expected_coords = [[7,5], [5,5], [4,6]]
    expected_coords.sort!
    actual_coords.sort!

    assert_equal(expected_coords, actual_coords)

    # Bottom-right knight
    knight = board.get_square(6,0).piece
    actual_coords = []

    knight.los.each do |sqr|
      actual_coords << sqr.coordinates
    end

    expected_coords = [[7,2], [4,1], [5,2]]
    expected_coords.sort!
    actual_coords.sort!

    assert_equal(expected_coords, actual_coords)

    # Bottom-left knight
    knight = board.get_square(1,0).piece
    actual_coords = []

    knight.los.each do |sqr|
      actual_coords << sqr.coordinates
    end

    expected_coords = [[2,2], [3,1], [0,2]]
    expected_coords.sort!
    actual_coords.sort!

    assert_equal(expected_coords, actual_coords)

    # Top-left knight
    knight = board.get_square(1,7).piece
    actual_coords = []

    knight.los.each do |sqr|
      actual_coords << sqr.coordinates
    end

    expected_coords = [[3,6], [2,5], [0,5]]
    expected_coords.sort!
    actual_coords.sort!

    assert_equal(expected_coords, actual_coords)
  end

  def test_los_of_bishops
  end

  def test_los_of_queens
  end

  def test_los_of_kings
  end

  def test_los_of_pawns
  end

#   def test_in_los_of
#     board = Board.new()
#     pawn = board.get_square(0,1).piece
#     rook = board.get_square(0,0).piece

#     assert(pawn.in_los_of.include? rook)
#   end
end
