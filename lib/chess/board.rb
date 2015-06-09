Dir[File.dirname(__FILE__) + '/pieces/*.rb'].each { |file| require file }
require_relative 'square'

class Board
  def initialize
    @squares_ary = self.gen_sqrs_ary()

    self.set_up_pawns()
    self.set_up_back_rows()
    self.set_los_of_default_pieces()
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

  def get_square(x, y)
#     puts "#{x}, #{y}"
    if !x.between?(0, @squares_ary.size-1) || !y.between?(0, @squares_ary.size-1)
      return nil
    end

    @squares_ary[x][y]
  end

  def set_los_of_default_pieces
    rows = [0, 1, 6, 7]
    cols = 0..7

    rows.each do |row|
      cols.each do |col|
        piece = self.get_square(col, row).piece

        piece.set_los()
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
        when 0, 7
          then sqr = self.get_square(col, row)
            sqr.piece = Rook.new(owner: owner, square: sqr)
        when 1, 6
          then sqr = self.get_square(col, row)
                sqr.piece = Knight.new(owner: owner, square: sqr)
        when 2, 5
          then sqr = self.get_square(col, row)
            sqr.piece = Bishop.new(owner: owner, square: sqr)
        when 3
          then sqr = self.get_square(col, row)
            sqr.piece = Queen.new(owner: owner, square: sqr)
        when 4
          then sqr = self.get_square(col, row)
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