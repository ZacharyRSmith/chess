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
  def initialize(coor, has = nil)
    @coor = coor
    @has = has
  end
  
  attr_accessor :coor, :has
  
  def has=(piece)
    @has = piece
  end
  
  def show
    if !self.has()
      "   "
    else   
      " " + self.has.icon() + self.has.owner()
    end
  end
end

class Game
  def initialize
    #$board = build_board()
    #set_up_pieces()
    #
    #until $game_over == true
    #  turn()
    #end	
  end
  
  def turn
    #set_player
    #show_board()
    #until move == true
    #  ask_move
    #  move()
    #end
  end
  
  def move(start, target)
    #check start for piece
    #check start for piece owner
    #check if target in piece LOS
    #check for self-check
    #...return reask_move(reason)
    #
    #change_squ
    #
    #check for check
    #...tell player
    #if checkmate then game_over
  end
  
  def game_over
  end
  
  def save
  end
  
  def load
  end
end

class Piece
  def initialize(owner = " ")
    @owner = owner
  end
  
  attr_reader :icon, :owner
end

class Pawn < Piece
  def initialize(owner = " ")
    super(owner)
    @icon = "p"
  end
end

class Knight < Piece
  def initialize(owner = " ")
    super(owner)
    @icon = "N"
  end
end

class Bishop < Piece
  def initialize(owner = " ")
    super(owner)
    @icon = "B"
  end
end

class Rook < Piece
  def initialize(owner = " ")
    super(owner)
    @icon = "R"
  end
end

class Queen < Piece
  def initialize(owner = " ")
    super(owner)
    @icon = "Q"
  end
end

class King < Piece
  def initialize(owner = " ")
    super(owner)
    @icon = "K"
  end
end  

def test_suite

  def new_squ
    # new square with only coordinates input
    test_squ = Square.new([0, 0])
    test_squ.coor == [0, 0] && 
      test_squ.has() == nil && 
      test_squ.show == "   "
  end

  def new_squ_with_piece
    # new square with coordinates and piece input
    pawn = Pawn.new()
    test_squ = Square.new([0, 0], pawn)
    test_squ.has().instance_of?(Pawn) &&
      test_squ.show() == " p " 
  end

  def all_tests
    fails = []
    tests = {
      new_squ: new_squ,
	  new_squ_with_piece: new_squ_with_piece
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
