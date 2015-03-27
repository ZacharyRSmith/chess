class Game
  def initialize
    $board = build_board()
    self.set_up_board()

    $game_over = false
    $player = ","

    @moved = false
    until $game_over == true
      turn()
    end
  end

  attr_accessor :board, :moved

  def change_player
    case $player
    when "," then $player = " "
    when " " then $player = ","
    end
  end

  def turn
    self.change_player()
    self.show_board()
    self.moved = false
    until self.moved == true
      puts "Player #{$player}, please select start coor X..."
      start_x = gets.chomp.to_i
      puts "Player #{$player}, please select start coor Y..."
      start_y = gets.chomp.to_i
      puts "Player #{$player}, please select target coor X..."
      tar_x = gets.chomp.to_i
      puts "Player #{$player}, please select target coor Y..."
      tar_y = gets.chomp.to_i
    #  move()
      move_message = move([start_x, start_y], [tar_x, tar_y], $player)
      puts move_message
    end
  end

  def move(start, tar, owner)
    start_squ = $board[start[0]][start[1]]
    piece = start_squ.has()
    tar_squ = $board[tar[0]][tar[1]]

    msg_help = "Please select a different move..."

    #check start for piece
    if !piece
      return "Error: The starting square you selected has no piece! " << msg_help
    end

    #check start for piece owner
    if piece.owner != owner
      return "Error: The piece you selected does not belong to you! " << msg_help
    end

    #check if target in piece LOS
    if !piece.los.include? tar_squ
      return "Error: That piece cannot maneuver in that way! " << msg_help
    end

    #check target for owner
    if tar_squ.has
      if tar_squ.has.owner == owner
        return "Error: You cannot attack yourself! " << msg_help
      end
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
    "Piece was moved."
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