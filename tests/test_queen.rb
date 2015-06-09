require './lib/chess/pieces/piece'
require './lib/chess/pieces/queen'
require './lib/chess/square'
require './lib/chess/board'
require 'minitest/autorun'

def gen_queen(coordinates: [0, 0], owner: " ")
  brd = Board.new()
  brd.clear_off_pieces()
  sqr = brd.get_square(coordinates[0], coordinates[1])
  Queen.new(square: sqr, owner: owner)
end


class TestQueen < MiniTest::Test
  def test_icon
    queen = gen_queen()
    assert_equal("Q", queen.icon)
  end

  def test_owner_with_comma
    queen = gen_queen(owner: ",")
    assert_equal(",", queen.owner)
  end

  def test_owner_with_blank
    queen = gen_queen(owner: " ")
    assert_equal(" ", queen.owner)
  end
end