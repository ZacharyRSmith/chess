def build_rook_los
  x_orig = self.square.coor[0]
  y_orig = self.square.coor[1]
  result_coor = []

  arr_1 = [-1, 1]

  for add_x in arr_1
    x_now = x_orig

    until !x_now.between?(0, 7)
      x_now = x_now + add_x

      # Redundant after the above until loop?
      if x_now.between?(0, 7)
        result_coor << [x_now, y_orig]

        if $board[x_now][y_orig].has
          break
        end
      end
    end
  end

  for add_y in arr_1
    y_now = y_orig

    until !y_now.between?(0, 7)
      y_now = y_now + add_y

      if y_now.between?(0, 7)
        result_coor << [x_orig, y_now]

        if $board[x_orig][y_now].has
          break
        end
      end
    end
  end

  rslt = []
  for coor in result_coor
    rslt << $board[coor[0]][coor[1]]
  end

  rslt
end