require_relative '../coor_helper'
require_relative 'bishop'
require_relative 'rook'
require_relative 'piece'

class Queen < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "Q"
  end

  def build_bishop_los()
    x_orig = self.square.coor[0]
    y_orig = self.square.coor[1]
    rslt_squares = []
    self.can_move = FALSE

    for add_x in [-1, 1]
      for add_y in [-1, 1]
        x_now = x_orig + add_x
        y_now = y_orig + add_y

        until !x_now.between?(0, 7) || !y_now.between?(0, 7)
          crnt_square = $board[x_now][y_now]

          if crnt_square.has() && crnt_square.has().owner == $player
            rslt_squares << crnt_square
            break
          elsif crnt_square.has()
            rslt_squares << crnt_square
            self.can_move = TRUE
            break
          else
            rslt_squares << crnt_square
            self.can_move = TRUE
          end
          x_now = x_now + add_x
          y_now = y_now + add_y
        end
      end
    end

    rslt_squares
  end

  def build_rook_los
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

  def los
    los = build_bishop_los()
    los + build_rook_los()
  end
end