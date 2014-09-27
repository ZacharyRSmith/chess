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
    $board = build_board()
    #set_up_pieces()
    #
    #until $game_over == true
    #  turn()
    #end	
  end
  
  attr_accessor :board, :move
  
  def turn
    #set_player
    #show_board()
    #until move == true
    #  ask_move
    #  if "save"...
    #  move()
    #end
  end
  
  def move(start, tar, owner)
    start_squ = $board[start[0]][start[1]]
    piece = start_squ.has()
    tar_squ = $board[tar[0]][tar[1]]
    
    #check start for piece
    if !piece
      return false
    end
    
    #check start for piece owner
    if piece.owner != owner
      return false
    end
    
    #check if target in piece LOS
    if !piece.los.include? tar_squ
      return false
    end
     
    #check for self-check
    #...return reask_move(reason)
    #
    #change_squ
    change_squ(start_squ, piece, tar_squ)
    
    #
    #check for check
    #...tell player
    #if checkmate then game_over
    true
  end
  
  def change_squ(start_squ, piece, tar_squ)
    piece.square = tar_squ
    start_squ.has = nil
    tar_squ.has = piece
    true
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
    set_up_back_rows()
  end
  
  def set_up_back_rows
    owners = [" ", ","]
    
    for owner in owners
      if owner == " "
        row = 7
      else
        row = 0
      end
      
      for col in 0..7
        case col
        when 0, 7 
          then $board[col][row].has=(Rook.new($board[col][row], owner))
        when 1, 6
          then $board[col][row].has=(Knight.new($board[col][row], owner))
        when 2, 5
          then $board[col][row].has=(Bishop.new($board[col][row], owner))
        when 3
          then $board[col][row].has=(Queen.new($board[col][row], owner))
        when 4
          then $board[col][row].has=(King.new($board[col][row], owner))
        end
      end
    end
  end

  def set_up_pawns
    owners = [" ", ","]
    
    for owner in owners
      case owner
      when " " then row = 6
      when "," then row = 1
      end
      
      for col in 0..7
        squ = $board[col][row]
        #problem
        squ.has=(Pawn.new(squ, owner))
      end
    end
  end

  def build_show_row_arr(row_num)
    top_3rd = ""
    mid_3rd = ""
    btm_3rd = ""
    
    for col_num in 0..7
      top_3rd << "   |"
      mid_3rd << "#{$board[col_num][row_num].show}|"
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
  def initialize(square, owner)
    @square = square  
    @owner = owner
  end
  
  attr_accessor :icon, :owner, :square, :moved, :los
end

class Pawn < Piece
  def initialize(square, owner)
    super(square, owner)
    @icon = "p"
    @moved = false
    @los = self.los()
  end
  
  def los
    rslt = []
    
    case @owner
    when " "
      then rslt << $board[@square.coor[0]][@square.coor[1] - 1]
    when ","
      then rslt << $board[@square.coor[0]][@square.coor[1] + 1]
    end
      
    rslt
  end
end

class Knight < Piece
  def initialize(square, owner)
    super(square, owner)
    @icon = "N"
  end
end

class Bishop < Piece
  def initialize(square, owner)
    super(square, owner)
    @icon = "B"
  end
end

class Rook < Piece
  def initialize(square, owner)
    super(square, owner)
    @icon = "R"
    @moved = false
  end
end

class Queen < Piece
  def initialize(square, owner)
    super(square, owner)
    @icon = "Q"
  end
end

class King < Piece
  def initialize(square, owner)
    super(square, owner)
    @icon = "K"
    @moved = false
  end
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

game = Game.new()
game.set_up_board()
game.show_board()

puts "\nFailing tests: #{test_suite.all_tests()}"

print game.move([0, 1], [0, 2], ",")
print $board[0][2].has.los[0].coor()
game.show_board()
#$board[0][2].has.moved()

puts "chess.rb terminated."
