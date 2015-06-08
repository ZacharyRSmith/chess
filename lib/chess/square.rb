class Square
  def initialize(board:, coordinates:, piece: nil)
    @board       = board
    @coordinates = coordinates
    @piece       = piece
  end

  attr_accessor :coordinates, :piece
  attr_reader   :board

#   def piece=(piece)
#     @piece = piece
#   end

  def show
    if !@piece
      "   "
    else
      " " + self.piece.icon + self.piece.owner
    end
  end
end