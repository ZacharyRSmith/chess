require_relative 'board'
require_relative '_helpers'

class Game
  def initialize
    @board = Board.new()

    @game_over = false
    @player = " "
  end

  attr_reader :board

  def change_player
    case @player
    when "," then @player = " "
    when " " then @player = ","
    end
  end

  def engine
    until @game_over == TRUE
      self.turn()
    end
  end

  def get_promotion_type(input)
    case input
    when 'Q' then
    when 'R' then
    when 'N' then
    when 'B' then
    end
  end
  
  def prompt_promotion
    puts "W@@T!! A PROMOTION!! Enter in your pawn's new type! (Ie: 'Q', 'R', 'N', or 'B')"
    input = gets.chomp.upcase!
    if !['Q', 'R', 'N', 'B'].include?(input)
      puts "Sorry, I didn't understand that input."
      return self.prompt_promotion()
    end

    input
  end

  def prompt_start_square
    puts "Player #{@player}, please enter in the square of the piece you want to move (eg, 'e4')..."
    input = gets.chomp

    start_sqr = @board.get_square_with_chess_notation(input)
    if !start_sqr
      puts "There is no square #{input}."
      return self.prompt_start_square()
    end

    start_piece = start_sqr.piece
    if !start_piece
      puts "There is no piece at square #{input}!"
      return self.prompt_start_square()
    end
    if start_piece.owner != @player
      puts "You cannot move your opponent's piece!"
      return self.prompt_start_square()
    end

    # FIXME Should not have to get/set los?
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

    target_sqr = @board.get_square_with_chess_notation(input)
    if !target_sqr
      puts "There is no square #{input}."
      return self.prompt_target_square(moving_piece)
    end
    if moving_piece.is_a? Pawn
      if target_sqr.piece &&
              target_sqr.coordinates[0] == moving_piece.square.coordinates[0]
        puts "You cannot attack forward with a pawn, only diagonally."
        return self.prompt_target_square(moving_piece)
      end
    end
    if target_sqr.piece && target_sqr.piece.owner == @player
      puts "You cannot attack your own piece!"
      return self.prompt_target_square(moving_piece)
    end
    if !moving_piece.los.include? target_sqr
      puts "Error: Your piece cannot maneuver in that way!"
      return self.prompt_target_square(moving_piece)
    end
    #FIXME Guard against self-check

    puts "You selected target square: #{input}."
    target_sqr
  end

  def turn
    @board.render()

    piece      = self.prompt_start_square().piece
    target_sqr = self.prompt_target_square(piece)

    if @board.move_promotes_pawn?(piece, target_sqr)
      promotion = self.prompt_promotion()
      @board.promote_pawn(piece, target_sqr, promotion)
    else
      @board.move_piece(piece, target_sqr)
    end

    self.change_player()
    if @board.is_checked?(@player)
      if @board.can_uncheck?(@player)
        puts "Player #{@player}, you are checked."
      else
        self.end_game()
      end
    end
  end

  def end_game
    @game_over = true
    @board.render()
    
    puts "Game over."
  end

  def save_game
  end

  def load_game
  end
end
