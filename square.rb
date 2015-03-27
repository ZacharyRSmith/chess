class Square
  def initialize(coor, has = nil)
    @coor = coor
    @has = has
  end

  attr_accessor :coor, :has

  def has=(piece)
    @has = piece
  end

  def show
    if !self.has()
      "   "
    else
      " " + self.has.icon() + self.has.owner()
    end
  end
end