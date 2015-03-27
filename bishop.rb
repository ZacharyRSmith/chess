require_relative 'piece'

class Bishop < Piece
  def initialize(square, owner, moved = false)
    super(square, owner, moved)
    @icon = "B"
  end

  def los
    los = build_bishop_los()
    los
  end
end