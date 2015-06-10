require_relative '_helpers'


class Square
  def initialize(board:, coordinates:, piece: nil)
    @board       = board
    @coordinates = coordinates
    @piece       = piece
  end

  attr_accessor :piece
  attr_reader   :board, :coordinates

  def get_notation
    file = get_chess_file_from_x_coord(@coordinates[0])
    rank = get_chess_rank_from_y_coord(@coordinates[1])

    file + rank
  end
  
  def show
    if !@piece
      "   "
    else
      " " + self.piece.icon + self.piece.owner
    end
  end
end
