puts "chess.rb initiated."

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
    @board = build_board()
    #set_up_pieces()
    #
    #until $game_over == true
    #  turn()
    #end	
  end
  
  attr_reader :board
  
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
  
  def build_board
    board = []
    
    for x in 0..7
      board << []
    end
    
    board.each_with_index do |x, i|
      for y in 0..7
        x << Square.new([i, y])
      end
    end
    
    board
  end
  
  def set_up_board
    set_up_pawns()
    set_up_rooks()
  end
  
  def set_up_pawns
    #sets White pawns
    for col in 0..7
      pawn = Pawn.new()
      @board[col][6].has=(pawn)
    end
    
    #sets Black pawns
    for col in 0..7
      pawn = Pawn.new(",")
      @board[col][1].has=(pawn)
    end
  end
  
  def set_up_rooks
    cols = [0, 7]
    
    for col in cols
      @board[col][0].has=(Rook.new(","))
    end
    
    for col in cols
      @board[col][7].has=(Rook.new(" "))
    end
  end
  
  def set_up_knights
  end
  
  def build_show_row_arr(row_num)
    top_3rd = ""
    mid_3rd = ""
    btm_3rd = ""
    
    for col_num in 0..7
      top_3rd << "   |"
      mid_3rd << "#{@board[col_num][row_num].show}|"
      btm_3rd << "___|"
    end
    
    show_row_arr = [top_3rd, mid_3rd, btm_3rd]
    show_row_arr
  end
  
  def show_board
    print "   _a_ _b_ _c_ _d_ _e_ _f_ _g_ _h_ "
    for row_num in 0..7
      show_row_arr = build_show_row_arr(row_num)
      print "\n  |#{show_row_arr[0]}"
      print "\n#{row_num + 1} |#{show_row_arr[1]}"
      print "\n  |#{show_row_arr[2]}" 
    end
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

game = Game.new
game.set_up_board()
game.show_board()
puts "Failing tests: #{test_suite.all_tests()}"

puts "chess.rb terminated."
