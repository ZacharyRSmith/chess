require_relative 'coor_helper'
require_relative 'piece'

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
      then direction = -1
    when ","
      then direction = 1
    end

    squ_in_front = squ_at_relative_coor(0, direction * 1)
    rslt << squ_in_front unless squ_in_front.has()

    if self.moved == false
      squ_two_in_front = squ_at_relative_coor(0, direction * 2)
	    rslt << squ_two_in_front unless squ_two_in_front.has() || squ_in_front.has()
 	  end

 	  arr = [-1, 1]
 	  for add_x in arr
 	    squ_at_front_diag = squ_at_relative_coor(add_x, direction * 1)

 	    if squ_at_front_diag
 	      if squ_at_front_diag.has()
 	        rslt << squ_at_front_diag
 	      end
 	    end
    end

    rslt
  end
end