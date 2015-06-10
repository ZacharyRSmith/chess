def get_chess_file_from_x_coord(x_coord)
  case x_coord
  when 0 then return "a"
  when 1 then return "b"
  when 2 then return "c"
  when 3 then return "d"
  when 4 then return "e"
  when 5 then return "f"
  when 6 then return "g"
  when 7 then return "h"
  end
end

def get_x_coord_from_chess_file(file)
  case file
  when "a" then return 0
  when "b" then return 1
  when "c" then return 2
  when "d" then return 3
  when "e" then return 4
  when "f" then return 5
  when "g" then return 6
  when "h" then return 7
  end
end


def get_chess_rank_from_y_coord(y_coord)
  case y_coord
  when 0 then return "1"
  when 1 then return "2"
  when 2 then return "3"
  when 3 then return "4"
  when 4 then return "5"
  when 5 then return "6"
  when 6 then return "7"
  when 7 then return "8"
  end
end
  
def get_y_coord_from_chess_rank(rank)
  case rank
  when "8" then return 7
  when "7" then return 6
  when "6" then return 5
  when "5" then return 4
  when "4" then return 3
  when "3" then return 2
  when "2" then return 1
  when "1" then return 0
  end
end
