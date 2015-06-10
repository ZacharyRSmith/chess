class Piece
  def initialize(owner: " ", square:)
    @board     = square.board
    @can_move  = FALSE
    # Every piece should have an @icon, but I am leaving that to child classes.
    @icon      = "X"
    @in_los_of = []
    @los       = []
    @moved     = false
    @owner     = owner
    @square    = square
  end

  attr_accessor :can_move, :icon, :in_los_of, :moved, :owner, :square
  attr_reader   :board, :los

  def can_uncheck?
    self.set_los()

    @los.each do |sqr|
      if self.move_leaves_self_unchecked?(sqr)

        return true
      end
    end
    
    return false
  end
  
  def move_leaves_self_unchecked?(sqr)
    orig_sqr = @square
    sqr_piece = sqr.piece
    @board.move_piece(self, sqr, true)
    
    if !@board.is_checked?(@owner)
      @square = orig_sqr
      orig_sqr.piece = self
      sqr.piece = sqr_piece
      sqr_piece.square = sqr if sqr_piece

      return true
    else
      @square = orig_sqr
      orig_sqr.piece = self
      sqr.piece = sqr_piece 
      sqr_piece.square = sqr if sqr_piece

      return false
    end
  end

  def set_los
    moves = self.get_moves()

    if moves.empty?
      @can_move = false
    else
      @can_move = true
    end
    @los = moves
  end
end
