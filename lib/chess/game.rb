require_relative 'board'

class Game
  def initialize
    @board = Board.new()
    @board.set_up_pawns()
    @board.set_up_back_rows()
    @game_over = false
    @player = ","

    until @game_over == true
      self.turn()
    end
  end

  attr_accessor :board

  def change_player
    case @player
    when "," then @player = " "
    when " " then @player = ","
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

  def prompt_start_square
    puts "Player #{@player}, please enter in the square of the piece you want to move (eg, 'e4')..."
    input = gets.chomp
    start_x = self.get_ind_from_ltr(input[0].downcase)
    start_y = input[1].to_i - 1

    start_sqr = @board.get_square(start_x, start_y)
    if !start_sqr
      puts "There is no square #{input}."
      return self.prompt_start_square()
    end
    if !start_sqr.piece
      puts "There is no piece at square #{input}!"
      return self.prompt_start_square()
    end

    start_piece = start_sqr.piece
    if start_piece.owner != @player
      puts "You cannot move your opponent's piece!"
      return self.prompt_start_square()
    end

    # FIXME Should not have to get/set los
    start_piece.set_los()
    if !start_piece.can_move
      puts "This piece cannot move!"
      return self.prompt_start_square()
    end
    # FIXME Guard against self-check

    puts "You selected square: #{input}."
    start_sqr
  end

  def prompt_target_square(moving_piece)
    puts "Now please enter in the square to where you want to move..."
    input = gets.chomp
    target_x = self.get_ind_from_ltr(input[0].downcase)
    target_y = input[1].to_i - 1
    if !target_x.between?(0, 7) || !target_y.between?(0, 7)
      puts "There is no square #{input}."
      return self.prompt_target_square(moving_piece)
    end
    target_sqr = @board.get_square(target_x, target_y)
    if target_sqr.piece
      if target_sqr.piece.owner == @player
        puts "You cannot attack your own piece!"
        return self.prompt_target_square(moving_piece)
      end
    end
    if !moving_piece.los.include?(target_sqr)
      puts "Error: Your piece cannot maneuver in that way!"
      return self.prompt_target_square(moving_piece)
    end
    #FIXME Guard against self-check

    puts "You selected target square: #{input}."
    target_sqr
  end

  def turn
    self.change_player()
    @board.render()

    start_sqr  = self.prompt_start_square()
    target_sqr = self.prompt_target_square(start_sqr.piece)
    self.move_piece(start_sqr, start_sqr.piece, target_sqr)
    # FIXME Check for check/checkmate
  end

  def move_piece(start_sqr, piece, tar_squ)
    piece.square    = tar_squ
    start_sqr.piece = nil
    tar_squ.piece   = piece
    piece.moved     = true
  end

  def game_over
  end

  def save
  end

  def load
  end
end