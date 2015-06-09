require_relative '../coor_helper'
require_relative 'piece'

class King < Piece
  def initialize(owner:, square:)
    super(owner: owner, square: square)
    @icon = "K"
  end

  def is_checked?
    if self.is_checked_by_bishop? || self.is_checked_by_king? ||
        self.is_checked_by_knight? || self.is_checked_by_pawn? ||
        self.is_checked_by_queen? || self.is_checked_by_rook?
      return TRUE
    else
      return FALSE
    end
  end

  def is_checked_by_bishop?
  end

  def is_checked_by_king?
  end

  def is_checked_by_knight?
  end

  def is_checked_by_pawn?
  end

  def is_checked_by_queen?
  end

  def is_checked_by_rook?
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

        if crnt_sqr.piece
          if crnt_sqr.piece.owner != @owner
            @can_move = TRUE
          end
        else
          @can_move = TRUE
        end

        rslt_sqrs << crnt_sqr
      end
    end

    @los = rslt_sqrs
  end
end