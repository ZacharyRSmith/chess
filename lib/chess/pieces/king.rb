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

  def can_castle_king_side?
    if @moved
      return false
    end
    if self.is_checked?
      return false
    end

    case @owner
    when " " then
      bishop_sqr = @board.get_square('f1')
      knight_sqr = @board.get_square('g1')
      rook_sqr   = @board.get_square('h1')
    when "," then
      bishop_sqr = @board.get_square('f8')
      knight_sqr = @board.get_square('g8')
      rook_sqr   = @board.get_square('h8')
    end
    
    if !bishop_sqr.piece &&
       self.move_leaves_self_unchecked?(bishop_sqr) &&
       !knight_sqr.piece &&
       self.move_leaves_self_unchecked?(knight_sqr) &&
       rook_sqr.piece &&
       !rook_sqr.piece.moved

      return true
    else
      return false
    end
  end
  
  def can_castle_queen_side?
    if @moved
      return false
    end
    if self.is_checked?
      return false
    end

    case @owner
    when " " then
      queen_sqr  = @board.get_square('d1')
      bishop_sqr = @board.get_square('c1')
      knight_sqr = @board.get_square('b1')
      rook_sqr   = @board.get_square('a1')
    when "," then
      queen_sqr  = @board.get_square('d8')
      bishop_sqr = @board.get_square('c8')
      knight_sqr = @board.get_square('b8')
      rook_sqr   = @board.get_square('a8')
    end
    
    if !queen_sqr.piece &&
       self.move_leaves_self_unchecked?(queen_sqr) &&
       !bishop_sqr.piece &&
       self.move_leaves_self_unchecked?(bishop_sqr) &&
       !knight_sqr.piece &&
       rook_sqr.piece &&
       !rook_sqr.piece.moved

      return true
    else
      return false
    end
  end

  def get_castle_king_side_sqr
    case @owner
    when " " then return @board.get_square('g1')
    when "," then return @board.get_square('g8')
    end
  end
  
  def get_castle_queen_side_sqr
    case @owner
    when " " then return @board.get_square('c1')
    when "," then return @board.get_square('c8')
    end
  end
  
  def get_moves
    rslt_sqrs = []
    x_orig = @square.coordinates[0]
    y_orig = @square.coordinates[1]
    
    if self.can_castle_king_side?
      rslt_sqrs << self.get_castle_king_side_sqr()
    end
    if self.can_castle_queen_side?
      rslt_sqrs << self.get_castle_queen_side_sqr()
    end

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
