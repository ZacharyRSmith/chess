require_relative '../coor_helper'
require_relative 'piece'

class Pawn < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)

    if @owner == " "
      @direction = -1
    else # @owner == ","
      @direction = 1
    end
    @icon = "p"
  end

  def los
    rslt_squares = []
    @can_move    = FALSE

    squ_in_front = squ_at_relative_coor(0, @direction * 1)
    if !squ_in_front.has()
      rslt_squares << squ_in_front
      @can_move = TRUE
    end

    if !@moved && !squ_in_front.has()
      squ_two_in_front = squ_at_relative_coor(0, @direction * 2)
      if !squ_two_in_front.has()
  	    rslt_squares << squ_two_in_front
        @can_move = TRUE
      end
 	  end

 	  for add_x in [-1, 1]
 	    squ_at_front_diag = squ_at_relative_coor(add_x, @direction * 1)

 	    if squ_at_front_diag && squ_at_front_diag.has() && squ_at_front_diag.has().owner != @owner
        rslt_squares << squ_at_front_diag
        @can_move = TRUE
 	    end
    end

    rslt_squares
  end
end