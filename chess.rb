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
    self.set_up_board()
    #set_up_pieces()
    $game_over = false
    $player = ","
    #
    @moved = false
    until $game_over == true
      turn()
    end	
  end
  
  attr_accessor :board, :moved
  
  def turn
    #set_player
    case $player
    when "," then $player = " "
    when " " then $player = ","
    end
    
    self.show_board()
    
    self.moved = false
    until self.moved == true
    
    #  ask_move
      puts "Player #{$player}, please select start coor X..."
      start_x = gets.chomp.to_i
      puts "Player #{$player}, please select start coor Y..."
      start_y = gets.chomp.to_i
      puts "Player #{$player}, please select target coor X..."
      tar_x = gets.chomp.to_i
      puts "Player #{$player}, please select target coor Y..."
      tar_y = gets.chomp.to_i
      
    #  if "save"...
    
    #  move()
      move([start_x, start_y], [tar_x, tar_y], $player)
    
    end
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
    
    self.moved = true
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
    piece.moved = true
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
  def initialize(square, owner, moved = false)
    @square = square  
    @owner = owner
    @moved = moved
  end
  
  attr_accessor :icon, :owner, :square, :moved, :los
end

class Pawn < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "p"
    @los = self.los()
  end
  
  def los
    rslt = []
    
    case @owner
    when " "
      then rslt << $board[@square.coor[0]][@square.coor[1] - 1] &&
        if self.moved == false
		  rslt << $board[@square.coor[0]][@square.coor[1] - 2]
		end
    when ","
      then rslt << $board[@square.coor[0]][@square.coor[1] + 1] &&
        if self.moved == false
		  rslt << $board[@square.coor[0]][@square.coor[1] + 2]
		end
    end
      
    rslt
  end
end

def new_coor_helper(x_orig, y_orig, add_x, add_y, result) 
  (x_new, y_new) = [(x_orig + add_x), (y_orig + add_y)]

  if x_new.between?(0, 7) && y_new.between?(0, 7)
    result << [x_new, y_new]
  end
  
  result
end

class Knight < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "N"
    @los = self.los()
  end
  
  def los
		x_orig = @square.coor[0]
		y_orig = @square.coor[1]
		result_coor = []

		arr_2 = [-2, 2]
		arr_1 = [-1, 1]
		
		for add_x in arr_2
			for add_y in arr_1
				result_coor = new_coor_helper(x_orig, y_orig, add_x, add_y, result_coor)
			end
		end
		
		for add_y in arr_2
			for add_x in arr_1
				result_coor = new_coor_helper(x_orig, y_orig, add_x, add_y, result_coor)
			end
		end  
		
		rslt = []
		for coor in result_coor
		  rslt << $board[coor[0]][coor[1]]
		end
		
		rslt
  end
end

class Bishop < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "B"
  end
end

class Rook < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "R"
    @moved = false
    @los = self.los()
  end
  
  def los
	x_orig = @square.coor[0]
	y_orig = @square.coor[1]
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
end

class Queen < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "Q"
  end
end

class King < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
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

tests_b()

puts "chess.rb terminated."
