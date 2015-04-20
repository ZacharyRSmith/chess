class Piece
  def initialize(square, owner, moved = false)
    @square = square
    @owner = owner
    @moved = moved
  end

  attr_accessor :icon, :owner, :square, :moved, :los
end