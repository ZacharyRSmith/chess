require_relative 'coor_helper'
require_relative 'piece'

class King < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "K"
    @moved = false
    @los = self.los()
  end

  def los
    rslt = build_king_los
    rslt
  end
end