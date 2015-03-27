require_relative 'piece'

class Knight < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "N"
    @los = self.los()
  end

  def los
	  los = build_knight_los()
	  los
  end
end