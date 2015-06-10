require_relative '../coor_helper'
require_relative 'piece'

class Rook < Piece
  def initialize(owner:, square:)
    super(owner: owner, square: square)
    @icon = "R"
  end

  def can_castle?
    if @moved
      return false
    else
      return true
    end
  end

  def get_moves
    rslt_sqrs = []
    x_orig = @square.coordinates[0]
    y_orig = @square.coordinates[1]

    for add_x in [-1, 1]
      x_now = x_orig + add_x
      crnt_sqr = @board.get_square(x_now, y_orig)

      until !crnt_sqr

        if crnt_sqr.piece
          if crnt_sqr.piece.owner == @owner
            break
          end

          rslt_sqrs << crnt_sqr if self.move_leaves_self_unchecked?(crnt_sqr)
          break
        else

          rslt_sqrs << crnt_sqr if self.move_leaves_self_unchecked?(crnt_sqr)
        end
        x_now += add_x
        crnt_sqr = @board.get_square(x_now, y_orig)
      end
    end

    for add_y in [-1, 1]
      y_now = y_orig + add_y
      crnt_sqr = @board.get_square(x_orig, y_now)

      until !crnt_sqr

        if crnt_sqr.piece
          if crnt_sqr.piece.owner == @owner
            break
          end

          rslt_sqrs << crnt_sqr if self.move_leaves_self_unchecked?(crnt_sqr)
          break
        else
          rslt_sqrs << crnt_sqr if self.move_leaves_self_unchecked?(crnt_sqr)
        end
        y_now += add_y
        crnt_sqr = @board.get_square(x_orig, y_now)
      end
    end

    rslt_sqrs
  end
end
