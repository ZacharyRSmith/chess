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

  def get_ind_from_ltr(ltr)
    case ltr
    when "a" then return 0
    when "b" then return 1
    when "c" then return 2
    when "d" then return 3
    when "e" then return 4
    when "f" then return 5
    when "g" then return 6
    when "h" then return 7
    end
  end

  def prompt_start_squ
    puts "Player #{$player}, please enter in the square of the piece you want to move (eg, 'e4')..."
    input = gets.chomp
    start_x = self.get_ind_from_ltr(input[0].downcase)
    start_y = input[1].to_i - 1
    if !start_x.between?(0, 7) || !start_y.between?(0, 7)
      puts "There is no square #{input}."
      return self.prompt_start_squ()
    end
    start_squ = $board[start_x][start_y]
    if !start_squ.has()
      puts "There is no piece at square #{input}!"
      return self.prompt_start_squ()
    end
    if start_squ.has().owner != $player
      puts "You cannot move your opponent's piece!"
      return self.prompt_start_squ()
    end

    puts "You selected square: #{input}."
    start_squ
  end

  def prompt_target_squ(moving_piece)
    puts "Now please enter in the square to where you want to move..."
    input = gets.chomp
    target_x = self.get_ind_from_ltr(input[0].downcase)
    target_y = input[1].to_i - 1
    if !target_x.between?(0, 7) || !target_y.between?(0, 7)
      puts "There is no square #{input}."
      return self.prompt_target_squ(moving_piece)
    end
    target_squ = $board[target_x][target_y]
    if target_squ.has()
      if target_squ.has().owner == $player
        puts "You cannot attack your own piece!"
        return self.prompt_target_squ(moving_piece)
      end
    end
    if !moving_piece.los.include?(target_squ)
      puts "Error: Your piece cannot maneuver in that way!"
      return self.prompt_target_squ(moving_piece)
    end
    #FIXME Guard against self-check

    puts "You selected target square: #{input}."
    target_squ
  end

  def turn
    self.change_player()
    self.show_board()

    start_squ = nil
    until start_squ && start_squ.has() && !start_squ.has().los.empty?
      start_squ  = self.prompt_start_squ()
    end
      # TEST CODE:
#     puts start_squ.has().los
    target_squ = self.prompt_target_squ(start_squ.has())
    self.move_piece(start_squ, start_squ.has(), target_squ)
    # FIXME Check for check/checkmate
  end

  def move_piece(start_squ, piece, tar_squ)
    piece.square  = tar_squ
    start_squ.has = nil
    tar_squ.has   = piece
    piece.moved   = true
  end

  def game_over
  end

  def save
  end

  def load
  end

  def build_board
    board = []

    for col_i in 0..7
      board << []
    end

    board.each_with_index do |col, col_i|
      for row_i in 0..7
        col << Square.new([col_i, row_i])
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