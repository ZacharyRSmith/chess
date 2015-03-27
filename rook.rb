require_relative 'coor_helper'
require_relative 'piece'

class Rook < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "R"
    @moved = false
    @los = self.los()
  end

  def los
		los = build_rook_los()
		los
  end
end