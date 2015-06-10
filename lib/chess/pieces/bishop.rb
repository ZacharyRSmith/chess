require_relative '../coor_helper'
require_relative 'piece'

class Bishop < Piece
  def initialize(owner:, square:)
    super(owner: owner, square: square)
    @icon = "B"
  end
  
  def is_blocking_self_from_check?
    case @owner
    when " " then king = @board.white_king
    when "," then king = @board.black_king
    end
    
    @square.piece = nil
    
    if king.is_checked?
      @square.piece = self
      return true
    else
      @square.piece = self
      return false
    end
  end
  
  def get_moves
    rslt_sqrs = []    
    x_orig = @square.coordinates[0]
    y_orig = @square.coordinates[1]

    for add_x in [-1, 1]
      for add_y in [-1, 1]
        x_now = x_orig + add_x
        y_now = y_orig + add_y
        crnt_sqr = @board.get_square(x_now, y_now)

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
          y_now += add_y
          crnt_sqr = @board.get_square(x_now, y_now)
        end
      end
    end
    
    rslt_sqrs
  end
end
