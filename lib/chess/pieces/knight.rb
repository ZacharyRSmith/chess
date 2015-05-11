require_relative '../coor_helper'
require_relative 'piece'

class Knight < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "N"
  end

  def set_los
    coordinates = @square.coordinates
    x_orig = coordinates[0]
    y_orig = coordinates[1]
    rslt_sqrs = []
    @can_move = FALSE

    for add_x in [-2, 2]
      for add_y in [-1, 1]
        x_now = x_orig + add_x
        y_now = y_orig + add_y
        crnt_sqr = $board.get_square(x_now, y_now)
        if !crnt_sqr
          next
        end

        if crnt_sqr.piece
          if crnt_sqr.piece.owner == $player
            rslt_sqrs << crnt_sqr
          else
            @can_move = TRUE
            rslt_sqrs << crnt_sqr
          end
        else
          rslt_sqrs << crnt_sqr
          @can_move = TRUE
        end
      end
    end

    for add_y in [-2, 2]
      for add_x in [-1, 1]
        x_now = x_orig + add_x
        y_now = y_orig + add_y
        crnt_sqr = $board.get_square(x_now, y_now)
        if !crnt_sqr
          next
        end

        if crnt_sqr.piece
          if crnt_sqr.piece.owner == $player
            rslt_sqrs << crnt_sqr
          else
            @can_move = TRUE
            rslt_sqrs << crnt_sqr
          end
        else
          @can_move = TRUE
          rslt_sqrs << crnt_sqr
        end
      end
    end

    @los = rslt_sqrs
  end
end