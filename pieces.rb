class Piece
  attr_reader :type, :color
  attr_accessor :position

  def initialize(color, type, position)
    @color = color
    @type = type
    @position = position
  end

end

class SlidingPiece < Piece
end

class Bishop < SlidingPiece
end

class Rook < SlidingPiece
end

class Queen < SlidingPiece
end

class SteppingPiece < Piece
end

class Knight < SteppingPiece
end

class King < SteppingPiece
end

class Pawn < Piece
end
