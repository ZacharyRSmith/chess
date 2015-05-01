require_relative '../coor_helper'
require_relative 'piece'

class Bishop < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "B"
  end

  def los
    x_orig = self.square.coor[0]
    y_orig = self.square.coor[1]
    rslt_squares = []

    for add_x in [-1, 1]
      for add_y in [-1, 1]
        x_now = x_orig + add_x
        y_now = y_orig + add_y

        until !x_now.between?(0, 7) || !y_now.between?(0, 7)
          crnt_square = $board[x_now][y_now]

          if crnt_square.has() && crnt_square.has().owner == $player
            break
          end
          rslt_squares << crnt_square

          if crnt_square.has()
            break
          end
          x_now = x_now + add_x
          y_now = y_now + add_y
        end
      end
    end

    rslt_squares
  end
end