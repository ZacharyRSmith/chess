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
    # direction determines how this pawn can move.
    if @owner == " "
      return -1
    else # @owner == ","
      return 1
    end
  end

  def set_los
    x_orig = @square.coordinates[0]
    y_orig = @square.coordinates[1]
    rslt_sqrs = []
    @can_move = FALSE

    sqr_in_front = @board.get_square(x_orig, y_orig + @direction)
    rslt_sqrs << sqr_in_front

    if !sqr_in_front.piece
      @can_move = TRUE
    end

    if !@moved && !sqr_in_front.piece
      sqr_two_in_front = @board.get_square(x_orig, y_orig + 2*@direction)
      rslt_sqrs << sqr_two_in_front
 	  end

 	  for add_x in [-1, 1]
      sqr_at_front_diag = @board.get_square(x_orig + add_x, y_orig + @direction)
      if sqr_at_front_diag && sqr_at_front_diag.piece &&
                                         sqr_at_front_diag.piece.owner != @owner
        @can_move = TRUE
        rslt_sqrs << sqr_at_front_diag
 	    end
    end

    @los = rslt_sqrs
  end
end