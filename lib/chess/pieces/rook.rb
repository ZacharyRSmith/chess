require_relative '../coor_helper'
require_relative 'piece'

class Rook < Piece
  def initialize(owner:, square:)
    super(owner: owner, square: square)
    @icon = "R"
  end

  def los
    x_orig = self.square.coor[0]
    y_orig = self.square.coor[1]
    rslt_squares = []

    for add_x in [-1, 1]
      x_now = x_orig + add_x
      until !x_now.between?(0, 7)
        crnt_square = $board[x_now][y_orig]

        if crnt_square.has() && crnt_square.has().owner == $player
          break
        end
        rslt_squares << crnt_square

        if crnt_square.has()
          break
        end
        x_now += add_x
      end
    end

    for add_y in [-1, 1]
      y_now = y_orig + add_y
      until !y_now.between?(0, 7)
        crnt_square = $board[x_orig][y_now]

        if crnt_square.has() && crnt_square.has().owner == $player
          break
        end
        rslt_squares << crnt_square

        if crnt_square.has()
          break
        end
        y_now += add_y
      end
    end

    rslt_squares
  end
end