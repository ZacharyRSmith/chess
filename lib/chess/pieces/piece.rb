class Piece
  def initialize(owner:, square:)
    @can_move  = FALSE
    # Every piece should have an @icon, but I am leaving that to child classes.
    # @icon      = "X"
    @in_los_of = []
    @los       = []
    @moved     = FALSE
    @owner     = owner
    @square    = square
  end

  attr_accessor :can_move, :icon, :in_los_of, :moved, :owner, :square

  def get_los
    @los
  end
end