def squ_at_relative_coor(add_x, add_y)
  print "\n#{self.square.coor}"
  new_x = self.square.coor[0] + add_x
  new_y = self.square.coor[1] + add_y

  if new_x.between?(0, 7) && new_y.between?(0, 7)
    return $board[new_x][new_y]
  end
end

def new_coor_helper(x_orig, y_orig, add_x, add_y, result)
  (x_new, y_new) = [(x_orig + add_x), (y_orig + add_y)]

  if x_new.between?(0, 7) && y_new.between?(0, 7)
    result << [x_new, y_new]
  end

  result
end