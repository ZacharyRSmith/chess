require_relative '../coor_helper'
require_relative '../los_helper'
require_relative 'piece'

class Bishop < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "B"
  end

  def los
    build_bishop_los()
  end
end