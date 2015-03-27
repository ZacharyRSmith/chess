require_relative 'coor_helper'
require_relative 'piece'

class Knight < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "N"
    @los = self.los()
  end

  def los
    x_orig = self.square.coor[0]
    y_orig = self.square.coor[1]
    result_coor = []

    arr_2 = [-2, 2]
    arr_1 = [-1, 1]

    for add_x in arr_2
      for add_y in arr_1
        result_coor = new_coor_helper(x_orig, y_orig, add_x, add_y, result_coor)
      end
    end

    for add_y in arr_2
      for add_x in arr_1
        result_coor = new_coor_helper(x_orig, y_orig, add_x, add_y, result_coor)
      end
    end

    rslt = []
    for coor in result_coor
      rslt << $board[coor[0]][coor[1]]
    end

    rslt
  end
end