require_relative '../coor_helper'
# bishop and rook are imported to help Queen.los()
require_relative 'bishop'
require_relative 'rook'
require_relative 'piece'

class Queen < Piece
  def initialize(owner:, square:)
    super(owner: owner, square: square)
    @icon = "Q"
  end

  def build_bishop_los()
    x_orig = @square.coor[0]
    y_orig = @square.coor[1]
    rslt_squares = []

    for add_x in [-1, 1]
      for add_y in [-1, 1]
        x_now = x_orig + add_x
        y_now = y_orig + add_y

        until !x_now.between?(0, 7) || !y_now.between?(0, 7)
          crnt_square = @board[x_now][y_now]

          if crnt_square.has() && crnt_square.has().owner == @owner
            rslt_squares << crnt_square
            break
          elsif crnt_square.has()
            rslt_squares << crnt_square
            @can_move = TRUE
            break
          else
            rslt_squares << crnt_square
            @can_move = TRUE
          end
          x_now = x_now + add_x
          y_now = y_now + add_y
        end
      end
    end

    rslt_squares
  end

  def build_rook_los
    x_orig = @square.coordinates[0]
    y_orig = @square.coordinates[1]
    rslt_squares = []

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

    rslt_squares
  end

  def set_los
    @can_move = FALSE
    @los = self.build_bishop_los() + self.build_rook_los()
  end
end