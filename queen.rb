require_relative 'coor_helper'
require_relative 'piece'

class Queen < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "Q"
    @los = self.los()
  end

  def los
    los = build_bishop_los()
    los = los + build_rook_los()
    los
  end
end