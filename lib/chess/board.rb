Dir[File.dirname(__FILE__) + '/pieces/*.rb'].each { |file| require file }
require_relative '_helpers'
require_relative 'square'


class Board
  def initialize
    @squares_ary = self.gen_sqrs_ary()

    sqr = self.get_square_with_chess_notation('e1')
    @white_king = King.new(owner: " ", square: sqr)
    sqr.piece = @white_king

    sqr = self.get_square_with_chess_notation('e8')
    @black_king = King.new(owner: ",", square: sqr)
    sqr.piece = @black_king

    self.set_up_pawns()
    self.set_up_back_rows()
    self.set_los_of_each_piece()
  end

  attr_reader :black_king, :white_king
  
  def can_uncheck?(player)
    @squares_ary.each do |col|
      col.each do |sqr|
        if sqr.piece && sqr.piece.owner == player
          return true if sqr.piece.can_uncheck?
        end
      end
    end
    
    return false
  end
  
  def clear_off_pieces
    @squares_ary = self.gen_sqrs_ary()
  end

  def gen_sqrs_ary
    sqrs_ary = []

    for col_i in 0..7
      sqrs_ary << []
    end

    sqrs_ary.each_with_index do |col, col_i|
      for row_i in 0..7
        col << Square.new(board: self, coordinates: [col_i, row_i])
      end
    end

    sqrs_ary
  end

  def gen_rendered_row_ary(row_num)
    top_3rd = ""
    mid_3rd = ""
    btm_3rd = ""

    for col_num in 0..7
      top_3rd << "   |"
      mid_3rd << "#{@squares_ary[col_num][row_num].show()}|"
      btm_3rd << "___|"
    end

    rendered_row_ary = [top_3rd, mid_3rd, btm_3rd]
    rendered_row_ary
  end

  def get_square(arg1, y=nil)
    if arg1.is_a?(String)
      x = get_x_coord_from_chess_file(arg1[0])
      y = get_y_coord_from_chess_rank(arg1[1])
      
      return @squares_ary[x][y]
    end
    
    if arg1 < 0 || y < 0
      return nil
    end

    return @squares_ary[arg1][y]
    
    rescue NoMethodError
      return nil
  end

  def get_square_with_chess_notation(chess_notation)
    begin
      x = get_x_coord_from_chess_file(chess_notation[0])
      y = get_y_coord_from_chess_rank(chess_notation[1])
      return @squares_ary[x][y]
    rescue NoMethodError
      return nil
    end
    
    return nil
  end

  def get_square_at_relative_coord(sqr, add_x, add_y)
    orig_x = sqr.coordinates[0]
    orig_y = sqr.coordinates[1]
  
    return self.get_square(orig_x + add_x, orig_y + add_y)
  end

  def is_checked?(player)
    case player
    when " " then return @white_king.is_checked?
    when "," then return @black_king.is_checked?
    end
  end

  def move_promotes_pawn?(piece, target_sqr)
    if piece.is_a?(Pawn) && [0, 7].include?(target_sqr.coordinates[1])
      return true
    else
      return false
    end
  end
  
  def move_piece(piece, target_sqr, mock=false)
    start_sqr = piece.square

    piece.square     = target_sqr
    start_sqr.piece  = nil
    target_sqr.piece = piece
    piece.moved      = true if !mock
  end
  
  def promote_pawn(pawn, target_sqr, promotion)
    self.move_piece(pawn, target_sqr)
    
    case promotion
    when 'Q' then
      target_sqr.piece = Queen.new(owner: pawn.owner, square: target_sqr)
    when 'R' then
      target_sqr.piece = Rook.new(owner: pawn.owner, square: target_sqr)
    when 'N' then
      target_sqr.piece = Knight.new(owner: pawn.owner, square: target_sqr)
    when 'B' then
      target_sqr.piece = Bishop.new(owner: pawn.owner, square: target_sqr)
    end
  end

  def set_los_of_each_piece
    @squares_ary.each do |col|
      col.each do |sqr|
        if sqr.piece
          sqr.piece.set_los()
        end
      end
    end
  end

  def set_up_back_rows
    for owner in [" ", ","]
      case owner
      when " " then row = 0
      when "," then row = 7
      end

      for col in 0..7
        case col
        when 0, 7 then
          sqr = self.get_square(col, row)
          sqr.piece = Rook.new(owner: owner, square: sqr)
        when 1, 6 then
          sqr = self.get_square(col, row)
          sqr.piece = Knight.new(owner: owner, square: sqr)
        when 2, 5 then
          sqr = self.get_square(col, row)
          sqr.piece = Bishop.new(owner: owner, square: sqr)
        when 3 then
          sqr = self.get_square(col, row)
          sqr.piece = Queen.new(owner: owner, square: sqr)
        end
      end
    end
  end

  def set_up_pawns
    for owner in [" ", ","]
      case owner
      when " " then row = 1
      when "," then row = 6
      end

      for col in 0..7
        sqr = self.get_square(col, row)
        sqr.piece = Pawn.new(owner: owner, square: sqr)
      end
    end
  end

  def render
    print "   _a_ _b_ _c_ _d_ _e_ _f_ _g_ _h_ "
    7.downto(0).each do |row_num|
#     for row_num in 0..7
      rendered_row_ary = gen_rendered_row_ary(row_num)
      print "\n  |#{rendered_row_ary[0]}"
      print "\n#{row_num + 1} |#{rendered_row_ary[1]}"
      print "\n  |#{rendered_row_ary[2]}"
    end
  end
end
