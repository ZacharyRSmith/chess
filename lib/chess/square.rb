class Square
  def initialize(board:, coordinates:, piece: nil)
    @board       = board
    @coordinates = coordinates
    @piece       = piece
  end

  attr_accessor :coordinates, :piece

#   def piece=(piece)
#     @piece = piece
#   end

  def show
    if !self.piece()
      "   "
    else
      " " + self.piece.icon() + self.piece.owner()
    end
  end
end