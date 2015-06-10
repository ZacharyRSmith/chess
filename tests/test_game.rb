require './lib/chess/game'
require 'minitest/autorun'


class TestGame < MiniTest::Test
  def test_has_board
    game = Game.new()
    
    assert(game.board)
  end
end
