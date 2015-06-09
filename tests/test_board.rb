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

  def test_pawns
    board = Board.new()

    [1, 6].each do |row|
      (0..7).each do |col|
        sqr = board.get_square(col, row)
        assert_instance_of(Pawn, sqr.piece)
      end
    end
  end

  def test_back_rows
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
end
