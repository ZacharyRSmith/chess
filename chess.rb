puts "chess.rb initiated."

#print "\n|   |   |   |   |   |   |   |   |"
#print "\n| R,| N,| B,| Q,| K,| B,| N,| R,|"
#print "\n|___|___|___|___|___|___|___|___|"
#print "\n|   |   |   |   |   |   |   |   |"
#print "\n| p*| p*| p*| p*| p*| p*| p*| p*|"
#print "\n|___|___|___|___|___|___|___|___|"
#print "\n|   |   |   |   |   |   |   |   |"
#print "\n|   |   |   |   |   |   |   |   |"
#print "\n|___|___|___|___|___|___|___|___|"

class Square
  def initialize(coor, has = nil, show = " ")
    @coor = coor
    @has = has
    @show = show
  end
  
  attr_reader :coor, :has, :show
  
  def has=(piece)
    @has = piece
  end
end

class Game
  def save
  end
  
  def load
  end
end

class Piece
  def initialize(coor)
    @coor = coor
  end
  
  attr_reader :coor, :icon
end

class Pawn < Piece
  @icon = "P"
end

class Knight < Piece
  @icon = "K"
end

class Bishop < Piece
  @icon = "B"
end

class Rook < Piece
end

class Queen < Piece
end

class King < Piece
end  

def test_suite

  def new_square
    # new square with only coordinates input
    test_squ = Square.new([0, 0])
    test_squ.coor == [0, 0] && 
      test_squ.has() == nil && 
      test_squ.show == " "
  end

  def test_3
    false
  end

  def all_tests
    fails = []
    tests = {
      new_square: new_square,
	  test_3: test_3
    }
  
    tests.each do |key, val|
      if !val
	    fails << key
	  end
    end
  
  fails
  end
end

puts "Failing tests: #{test_suite.all_tests()}"

puts "chess.rb terminated."
