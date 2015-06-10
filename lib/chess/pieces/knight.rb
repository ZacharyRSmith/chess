require_relative '../coor_helper'
require_relative 'piece'

class Knight < Piece
  def initialize(owner:, square:)
    super(owner: owner, square: square)
    @icon = "N"
  end

  def get_moves
    x_orig = @square.coordinates[0]
    y_orig = @square.coordinates[1]
    rslt_sqrs = []

    for add_x in [-2, 2]
      for add_y in [-1, 1]
        x_now = x_orig + add_x
        y_now = y_orig + add_y
        crnt_sqr = @board.get_square(x_now, y_now)
        if !crnt_sqr
          next
        end

        if crnt_sqr.piece
          if crnt_sqr.piece.owner == @owner
            next
          end
          
          rslt_sqrs << crnt_sqr if self.move_leaves_self_unchecked?(crnt_sqr)
        else
          rslt_sqrs << crnt_sqr if self.move_leaves_self_unchecked?(crnt_sqr)
        end
      end
    end

    for add_y in [-2, 2]
      for add_x in [-1, 1]
        x_now = x_orig + add_x
        y_now = y_orig + add_y
        crnt_sqr = @board.get_square(x_now, y_now)
        if !crnt_sqr
          next
        end

        if crnt_sqr.piece
          if crnt_sqr.piece.owner == @owner
            next
          end

          rslt_sqrs << crnt_sqr if self.move_leaves_self_unchecked?(crnt_sqr)
        else
          rslt_sqrs << crnt_sqr if self.move_leaves_self_unchecked?(crnt_sqr)
        end
      end
    end

    rslt_sqrs
  end
end
