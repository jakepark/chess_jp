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

  def move(start_pos, end_pos)
    self.class::DELTA.any? do |delta|
      current_board.valid_move_step?(start_pos, end_pos, delta)
    end
  end

end

class SlidingPiece < Piece
  def initialize(color, position, current_board)#, position, grid)
    super(color, position, current_board)#, position, grid)
  end

  def get_delta(start_pos, end_pos)
    x_delta = end_pos[0] - start_pos[0]
    y_delta = end_pos[1] - start_pos[1]

    self.class::DELTA.each do |deltoid|
      return deltoid if (1..7).to_a.any? do |multiple|
        multiple * deltoid[0] == x_delta &&
        multiple * deltoid[1] == y_delta
      end
    end
  end
end

class Bishop < SlidingPiece

  DELTA = [
    [ 1, 1],
    [ 1,-1],
    [-1, 1],
    [-1,-1]
  ]

  def initialize(color, position, current_board)#, position, grid)
    super(color, position, current_board)#, position, grid)
  end

end

class Rook < SlidingPiece

  DELTA = [
    [ 1, 0],
    [-1, 0],
    [ 0, 1],
    [ 0,-1]
  ]

  def initialize(color, position, current_board)#, position, grid)
    super(color, position, current_board)#, position, grid)
  end

end

class Queen < SlidingPiece

  DELTA = [
    [ 1, 0],
    [-1, 0],
    [ 0, 1],
    [ 0,-1],
    [ 1, 1],
    [ 1,-1],
    [-1, 1],
    [-1,-1]
  ]

  def initialize(color, position, current_board)#, position, grid)
    super(color, position, current_board)#, position, grid)
  end

end

class SteppingPiece < Piece
  def initialize(color, position, current_board)#, position, grid)
    super(color, position, current_board)#, position, grid)
  end

end

class Knight < SteppingPiece
#  def initialize(color, position, grid)
  DELTA = [
    [ 2,  1],
    [ 2, -1],
    [-2,  1],
    [-2, -2],
    [ 1,  2],
    [ 1, -2],
    [-1,  2],
    [-1, -2]
  ]

  def initialize(color, position, current_board)#, position, grid)
    super(color, position, current_board)#, position, grid)
  end








end

class King < SteppingPiece

  DELTA = [
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

class Pawn < Piece
end
