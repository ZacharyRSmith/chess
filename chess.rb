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

def build_bishop_los
  x_orig = self.square.coor[0]
  y_orig = self.square.coor[1]
  result_coor = []

  arr_1 = [-1, 1]

  for add_x in arr_1
    for add_y in arr_1
      x_now = x_orig
      y_now = y_orig

    until !x_now.between?(0, 7) || !y_now.between?(0, 7)
    x_now = x_now + add_x
    y_now = y_now + add_y

    if x_now.between?(0, 7) && y_now.between?(0, 7)
      result_coor << [x_now, y_now]

      if $board[x_now][y_now].has
        break
      end
    end
  end
end
end

rslt = []
for coor in result_coor
  rslt << $board[coor[0]][coor[1]]
end

rslt
end

def build_rook_los
  x_orig = self.square.coor[0]
  y_orig = self.square.coor[1]
  result_coor = []

  arr_1 = [-1, 1]

  for add_x in arr_1
    x_now = x_orig

  until !x_now.between?(0, 7)
  x_now = x_now + add_x

  if x_now.between?(0, 7)
    result_coor << [x_now, y_orig]

    if $board[x_now][y_orig].has
      break
    end
  end
end
end

for add_y in arr_1
  y_now = y_orig

until !y_now.between?(0, 7)
y_now = y_now + add_y

if y_now.between?(0, 7)
  result_coor << [x_orig, y_now]

  if $board[x_orig][y_now].has
    break
  end
end
end
end

rslt = []
for coor in result_coor
  rslt << $board[coor[0]][coor[1]]
end

rslt
end

def build_king_los
  x_orig = self.square.coor[0]
  y_orig = self.square.coor[1]
  result_coor = []

  arr = [-1, 0, 1]

  for add_x in arr
    for add_y in arr
      x_now = x_orig + add_x
      y_now = y_orig + add_y

      if x_now.between?(0, 7) && y_now.between?(0, 7)
        result_coor << [x_now, y_now]
      end
    end
  end

  rslt = []
  for coor in result_coor
    rslt << $board[coor[0]][coor[1]]
  end

  rslt
end

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
