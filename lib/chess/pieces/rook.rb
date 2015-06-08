require_relative '../coor_helper'
require_relative 'piece'

class Rook < Piece
  def initialize(owner:, square:)
    super(owner: owner, square: square)
    @icon = "R"
  end

  def set_los
    x_orig = @square.coordinates[0]
    y_orig = @square.coordinates[1]
    rslt_squares = []
    @can_move = FALSE

    for add_x in [-1, 1]
      x_now = x_orig + add_x

      crnt_square = @board.get_square(x_now, y_orig)
      until !crnt_square

        if crnt_square.piece && crnt_square.piece.owner == @owner
          rslt_squares << crnt_square
          break
        elsif crnt_square.piece
          @can_move = TRUE
          rslt_squares << crnt_square
          break
        else
          @can_move = TRUE
          rslt_squares << crnt_square
        end
        x_now += add_x
        crnt_square = @board.get_square(x_now, y_orig)
      end
    end

    for add_y in [-1, 1]
      y_now = y_orig + add_y

      crnt_square = @board.get_square(x_orig, y_now)
      until !crnt_square

        if crnt_square.piece && crnt_square.piece.owner == @owner
          rslt_squares << crnt_square
          break
        elsif crnt_square.piece
          @can_move = TRUE
          rslt_squares << crnt_square
          break
        else
          @can_move = TRUE
          rslt_squares << crnt_square
        end
        y_now += add_y
        crnt_square = @board.get_square(x_orig, y_now)
      end
    end

    @los = rslt_squares
  end
end