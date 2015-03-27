#remaining: en passe for Pawn, promote for Pawn, castling, re-calc LOS,
#look for check/checkmate, delete piece from board
puts "chess.rb initiated."

require_relative 'bishop'
require_relative 'game'
require_relative 'king'
require_relative 'knight'
require_relative 'pawn'
require_relative 'piece'
require_relative 'queen'
require_relative 'rook'
require_relative 'square'

def test_suite

  def test_has_icon_on_square
    game = Game.new()
    game.set_up_board()
    $board[0][0].has.icon == "R"
  end

  def all_tests
    fails = []
    tests = {
      test_has_icon_on_square: test_has_icon_on_square()
      }

    tests.each do |key, val|
      if !val
        fails << key
      end
    end

    fails
  end
end

def tests_a
game = Game.new()
game.set_up_board()
game.show_board()

puts "\nFailing tests: #{test_suite.all_tests()}"

print game.move([0, 1], [0, 3], ",")
print game.move([1, 0], [2, 2], ",")
print game.move([2, 2], [4, 1], ",")
print game.move([0, 0], [0, 2], ",")
print $board[0][3].has.los[0].coor()
puts game.show_board()
puts $board[0][2].has.los.each { |squ| print "\n#{squ.coor}" }
puts $board[0][3].has.moved()
end

def tests_b
  game = Game.new()
end

tests_a()

puts "chess.rb terminated."
