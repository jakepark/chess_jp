class Piece
  attr_reader :type, :color, :moves
  attr_accessor :position, :current_board

  def initialize(color, position, current_board)#, position, grid)
    @color = color
    # might become redundant
    @position = position
    @current_board = current_board
  end

  def inspect
    name = "#{self.class}"[0]
    color = "#{self.color}"[0]
    "[#{name}-#{color}]"

  #  "[#{self.class}, #{color}, #{position}]"
  end
end
#
# class SlidingPiece < Piece
#   ROOK_DELTA = [
#     [ 1, 0],
#     [-1, 0],
#     [ 0, 1],
#     [ 0,-1]
#   ]
#
#   BISHOP_DELTA = [
#     [ 1, 1],
#     [ 1,-1],
#     [-1, 1],
#     [-1,-1]
#   ]
#
# end
#
# class Bishop < SlidingPiece
# end
#
# class Rook < SlidingPiece
# end
#
# class Queen < SlidingPiece
# end

class SteppingPiece < Piece
  def initialize(color, position, current_board)#, position, grid)
    super(color, position, current_board)#, position, grid)
  end


    KNIGHT_DELTA = [
      [ 2,  1],
      [ 2, -1],
      [-2,  1],
      [-2, -2],
      [ 1,  2],
      [ 1, -2],
      [-1,  2],
      [-1, -2]
    ]

    KING_DELTA = [
      [ 1, 1],
      [ 1,-1],
      [-1, 1],
      [-1,-1],
      [ 1, 0],
      [-1, 0],
      [ 0, 1],
      [ 0,-1],
    ]

end

class Knight < SteppingPiece
#  def initialize(color, position, grid)
  def initialize(color, position, current_board)#, position, grid)
    super(color, position, current_board)#, position, grid)
  end

  def move(start_pos, end_pos)
    KNIGHT_DELTA.any? do |delta|
      current_board.valid_move?(start_pos, end_pos, delta)
    end


  end







end

class King < SteppingPiece
end

class Pawn < Piece
end
