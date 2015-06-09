require_relative '../coor_helper'
require_relative 'piece'

class King < Piece
  def initialize(owner:, square:)
    super(owner: owner, square: square)
    @icon = "K"
  end

  def set_los
    x_orig = @square.coordinates[0]
    y_orig = @square.coordinates[1]
    rslt_sqrs = []
    @can_move = FALSE

    for add_x in [-1, 0, 1]
      for add_y in [-1, 0, 1]
        x_now = x_orig + add_x
        y_now = y_orig + add_y

        crnt_sqr = @board.get_square(x_now, y_now)
        if !crnt_sqr
          next
        end

        rslt_sqrs << crnt_sqr
      end
    end

    @los = rslt_sqrs
  end
end