require_relative '../coor_helper'
require_relative '../los_helper'
require_relative 'piece'

class Queen < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "Q"
  end

  def los
    los = build_bishop_los()
    los + build_rook_los()
  end
end