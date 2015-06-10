require_relative '../coor_helper'
require_relative 'piece'

class King < Piece
  def initialize(owner:, square:)
    super(owner: owner, square: square)
    @icon = "K"
  end

  def is_checked?
    if self.is_checked_by_bishop_or_queen_diagonally? ||
        self.is_checked_by_king? ||
        self.is_checked_by_knight? ||
        self.is_checked_by_pawn? ||
        self.is_checked_by_rook_or_queen_orthogonally?
      return TRUE
    else
      return FALSE
    end
  end

  def is_checked_by_bishop_or_queen_diagonally?
    x_orig = @square.coordinates[0]
    y_orig = @square.coordinates[1]

    for add_x in [-1, 1]
      for add_y in [-1, 1]
        x_now = x_orig + add_x
        y_now = y_orig + add_y
        crnt_sqr = @board.get_square(x_now, y_now)

        until !crnt_sqr
          if crnt_sqr.piece && crnt_sqr.piece.owner == @owner
            break
          end
          
          if crnt_sqr.piece && crnt_sqr.piece.owner != @owner &&
             (crnt_sqr.piece.is_a?(Bishop) || crnt_sqr.piece.is_a?(Queen))
            
            #puts crnt_sqr.get_notation()
            
            return true
          end
          x_now += add_x
          y_now += add_y
          crnt_sqr = @board.get_square(x_now, y_now)
        end
      end
    end
    
    return false
  end

  def is_checked_by_king?
    x_orig = @square.coordinates[0]
    y_orig = @square.coordinates[1]

    for add_x in [-1, 0, 1]
      for add_y in [-1, 0, 1]
        if add_x == 0 && add_y == 0
          next
        end

        x_now = x_orig + add_x
        y_now = y_orig + add_y
        crnt_sqr = @board.get_square(x_now, y_now)

        if !crnt_sqr
          next
        end

        # No further conditionals are needed since another King is
        # by default an opponent piece.
        if crnt_sqr.piece && crnt_sqr.piece.is_a?(King)
          return TRUE
        end
      end
    end

    return FALSE
  end

  def is_checked_by_knight?
    x_orig = @square.coordinates[0]
    y_orig = @square.coordinates[1]

    for add_x in [-2, 2]
      for add_y in [-1, 1]
        x_now = x_orig + add_x
        y_now = y_orig + add_y
        crnt_sqr = @board.get_square(x_now, y_now)
        if !crnt_sqr
          next
        end

        if crnt_sqr.piece && crnt_sqr.piece.owner != @owner &&
           crnt_sqr.piece.is_a?(Knight)
          return TRUE
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

        if crnt_sqr.piece && crnt_sqr.piece.owner != @owner &&
           crnt_sqr.piece.is_a?(Knight)
          return TRUE
        end
      end
    end
    
    return FALSE
  end

  def is_checked_by_pawn?
    case @owner
    when " " then add_y = 1
    when "," then add_y = -1
    end
    
    for add_x in [-1, 1]
      sqr = @board.get_square_at_relative_coord(@square, add_x, add_y)
      
      if sqr && sqr.piece && sqr.piece.owner != @owner &&
         sqr.piece.is_a?(Pawn)
        return TRUE
      end
    end
    
    return FALSE
  end

  def is_checked_by_rook_or_queen_orthogonally?
    x_orig = @square.coordinates[0]
    y_orig = @square.coordinates[1]

    for add_x in [-1, 1]
      x_now = x_orig + add_x
      crnt_sqr = @board.get_square(x_now, y_orig)

      until !crnt_sqr

        if crnt_sqr.piece && crnt_sqr.piece.owner == @owner
          break
        end
        
        if crnt_sqr.piece && crnt_sqr.piece.owner != @owner &&
           (crnt_sqr.piece.is_a?(Rook) || crnt_sqr.piece.is_a?(Queen))
          return TRUE
        end

        x_now += add_x
        crnt_sqr = @board.get_square(x_now, y_orig)
      end
    end

    for add_y in [-1, 1]
      y_now = y_orig + add_y

      crnt_sqr = @board.get_square(x_orig, y_now)
      until !crnt_sqr
      
        if crnt_sqr.piece && crnt_sqr.piece.owner == @owner
          break
        end
          
        if crnt_sqr.piece && crnt_sqr.piece.owner != @owner &&
           (crnt_sqr.piece.is_a?(Rook) || crnt_sqr.piece.is_a?(Queen))
          return TRUE
        end

        y_now += add_y
        crnt_sqr = @board.get_square(x_orig, y_now)
      end
    end
    
    return FALSE
  end

  def get_moves
    rslt_sqrs = []
    x_orig = @square.coordinates[0]
    y_orig = @square.coordinates[1]

    for add_x in [-1, 0, 1]
      for add_y in [-1, 0, 1]
        if add_x == 0 && add_y == 0
          next
        end
        x_now = x_orig + add_x
        y_now = y_orig + add_y
        crnt_sqr = @board.get_square(x_now, y_now)

        if !crnt_sqr
          next
        end

        if crnt_sqr.piece
          if crnt_sqr.piece.owner != @owner
            rslt_sqrs << crnt_sqr if self.move_leaves_self_unchecked?(crnt_sqr)
          end
        else
          rslt_sqrs << crnt_sqr if self.move_leaves_self_unchecked?(crnt_sqr)
        end
      end
    end

    rslt_sqrs
  end
end
