require_relative '../coor_helper'
require_relative 'piece'

class Bishop < Piece
  def initialize(owner:, square:)
    super(owner: owner, square: square)
    @icon = "B"
  end

  def set_los
    x_orig = @square.coordinates[0]
    y_orig = @square.coordinates[1]
    rslt_sqrs = []
    @can_move = FALSE

    for add_x in [-1, 1]
      for add_y in [-1, 1]
        x_now = x_orig + add_x
        y_now = y_orig + add_y
        crnt_sqr = @board.get_square(x_now, y_now)

        until !crnt_sqr
          if crnt_sqr.piece && crnt_sqr.piece.owner == @owner
            rslt_sqrs << crnt_sqr
            break
          elsif crnt_sqr.piece
            @can_move = TRUE
            rslt_sqrs << crnt_sqr
            break
          else
            @can_move = TRUE
            rslt_sqrs << crnt_sqr
          end
          x_now = x_now + add_x
          y_now = y_now + add_y
      
#       print x_now, y_now, "\n"
#       print @board.get_square(7, 7).piece
      
          crnt_sqr = @board.get_square(x_now, y_now)
        end
      end
    end

    @los = rslt_sqrs
  end
end