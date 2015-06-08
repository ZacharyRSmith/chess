require_relative '../coor_helper'
require_relative 'piece'

class King < Piece
  def initialize(owner:, square:)
    super(owner: owner, square: square)
    @icon = "K"
  end

  def los
    x_orig = @square.coor[0]
    y_orig = @square.coor[1]
    result_coor = []

    arr = [-1, 0, 1]

    for add_x in arr
      for add_y in arr
        x_now = x_orig + add_x
        y_now = y_orig + add_y

        if x_now.between?(0, 7) && y_now.between?(0, 7)
          result_coor << [x_now, y_now]
        end
      end
    end

    rslt = []
    for coor in result_coor
      rslt << @board[coor[0]][coor[1]]
    end

    rslt
  end
end