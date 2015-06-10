require_relative '../coor_helper'
require_relative 'piece'

class Pawn < Piece
  def initialize(owner:, square:)
    super(owner: owner, square: square)
    # direction determines how this pawn can move.
    @direction = set_direction
    @icon      = "p"
  end

  attr_reader :direction

  def set_direction
    case @owner
    when " " then return 1
    when "," then return -1
    end
  end

  def get_moves
    rslt_sqrs = []
    x_orig = @square.coordinates[0]
    y_orig = @square.coordinates[1]

    sqr_in_front = @board.get_square(x_orig, y_orig + @direction)
    
    if !sqr_in_front.piece
      rslt_sqrs << sqr_in_front if self.move_leaves_self_unchecked?(sqr_in_front)
    end

    if !@moved && !sqr_in_front.piece
      sqr_two_in_front = @board.get_square(x_orig, y_orig + 2*@direction)

      if !sqr_two_in_front.piece
        rslt_sqrs << sqr_two_in_front if self.move_leaves_self_unchecked?(sqr_two_in_front)
      end
 	  end

 	  for add_x in [-1, 1]
      sqr_at_front_diag = @board.get_square(x_orig + add_x, y_orig + @direction)

      if sqr_at_front_diag && sqr_at_front_diag.piece &&
                                         sqr_at_front_diag.piece.owner != @owner

        rslt_sqrs << sqr_at_front_diag if self.move_leaves_self_unchecked?(sqr_at_front_diag)
 	    end
    end

    rslt_sqrs
  end
end
