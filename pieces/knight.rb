require_relative '../coor_helper'
require_relative 'piece'

class Knight < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "N"
  end

  def los
    x_orig = self.square.coor[0]
    y_orig = self.square.coor[1]
    rslt_squares = []
    self.can_move = FALSE

    for add_x in [-2, 2]
      for add_y in [-1, 1]
        x_now = x_orig + add_x
        y_now = y_orig + add_y

        if !x_now.between?(0, 7) || !y_now.between?(0, 7)
          next
        end
        crnt_square = $board[x_now][y_now]
        if crnt_square.has() && crnt_square.has().owner == $player
          rslt_squares << crnt_square
        elsif crnt_square.has()
          rslt_squares << crnt_square
          self.can_move = TRUE
        else # crnt_square has no piece.
          rslt_squares << crnt_square
          self.can_move = TRUE
        end
      end
    end

    for add_y in [-2, 2]
      for add_x in [-1, 1]
        x_now = x_orig + add_x
        y_now = y_orig + add_y

        if !x_now.between?(0, 7) || !y_now.between?(0, 7)
          next
        end
        crnt_square = $board[x_now][y_now]
        if crnt_square.has() && crnt_square.has().owner == $player
          rslt_squares << crnt_square
        elsif crnt_square.has()
          rslt_squares << crnt_square
          self.can_move = TRUE
        else # crnt_square has no piece.
          rslt_squares << crnt_square
          self.can_move = TRUE
        end
      end
    end

    rslt_squares
  end
end