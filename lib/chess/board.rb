Dir[File.dirname(__FILE__) + '/pieces/*.rb'].each { |file| require file }
require_relative '_helpers'
require_relative 'square'


class Board
  def initialize
    @squares_ary = self.gen_sqrs_ary()

    self.set_up_pawns()
    self.set_up_back_rows()
    @black_king            = self.get_square('e8').piece
    @white_king            = self.get_square('e1').piece
    
    self.set_los_of_each_piece()
  end

  attr_accessor :black_king, :white_king
  
  def can_move?(player)
    @squares_ary.each do |col|
      col.each do |sqr|
        if sqr.piece && sqr.piece.owner == player
          sqr.piece.set_los()
          
          if sqr.piece.can_move
            return true
          end
        end
      end
    end
    
    return false
  end

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
  
  def castle(king, target_sqr)
    start_sqr        = king.square
    king.square      = target_sqr
    start_sqr.piece  = nil
    target_sqr.piece = king
    king.moved       = true
    
    rook_hash = self.get_castling_rook_hash(target_sqr)
    self.move_piece(rook_hash['rook'], rook_hash['sqr'])
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

  def get_castling_rook_hash(kings_castling_sqr)
    rslt = {}
    
    case kings_castling_sqr.get_notation()
    when 'g1' then
      rslt['rook'] = self.get_square('h1').piece
      rslt['sqr']  = self.get_square('f1')
      return rslt
    when 'c1' then
      rslt['rook'] = self.get_square('a1').piece
      rslt['sqr']  = self.get_square('d1')
      return rslt
    when 'g8' then
      rslt['rook'] = self.get_square('h8').piece
      rslt['sqr']  = self.get_square('f8')
      return rslt
    when 'c8' then
      rslt['rook'] = self.get_square('a8').piece
      rslt['sqr']  = self.get_square('d8')
      return rslt
    end
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

  def move_is_castling?(piece, target_sqr)
    if !piece.is_a?(King)
      return false
    end
    if piece.moved
      return false
    end
    
    castling_sqrs = []
    castling_sqrs << self.get_square('g1') # White king-side
    castling_sqrs << self.get_square('c1') # White queen-side
    castling_sqrs << self.get_square('g8') # Black king-side
    castling_sqrs << self.get_square('c8') # Black queen-side
    
    if castling_sqrs.include?(target_sqr)
      return true
    else
      return false
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
    start_sqr        = piece.square
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
        when 4 then
          sqr = self.get_square(col, row)
          sqr.piece = King.new(owner: owner, square: sqr)
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
