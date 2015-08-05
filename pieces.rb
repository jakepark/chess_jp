require 'byebug'
require_relative 'board.rb'

class Array
  def multiply_array(other_array)
    product_array = []
    self.each_index{|idx| product_array << (self[idx] * other_array[idx]) }
    product_array
  end
end

class Piece
  attr_reader :type, :color, :moves
  attr_accessor :position, :current_board

  def initialize(color, position, current_board)
    @color = color
    @position = position
    @current_board = current_board
  end

  def inspect
    name = "#{self.class}"[0]
    color = "#{self.color}"[0]
    "[#{name}-#{color}]"

  #  "[#{self.class}, #{color}, #{position}]"
  end

  def icon
    name = "#{self.class}"[0]
    if @color == :white
      name = name.colorize(:red)
    else
      name = name.colorize(:green)
    end

    "#{name}"
  end

  def move(start_pos, end_pos)
    self.class::DELTA.any? do |delta|
      current_board.valid_move?(start_pos, end_pos)
    end
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

    nil
  end

end

class SlidingPiece < Piece
  def initialize(color, position, current_board)#, position, grid)
    super(color, position, current_board)#, position, grid)
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

  def get_delta(start_pos, end_pos)
    x_delta = end_pos[0] - start_pos[0]
    y_delta = end_pos[1] - start_pos[1]
    [x_delta, y_delta]
  end
end

class Horse < SteppingPiece
#  def initialize(color, position, grid)
  DELTA = [
    [ 2,  1],
    [ 2, -1],
    [-2,  1],
    [-2, -1],
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

  def initialize(color, position, current_board)#, position, grid)
    super(color, position, current_board)#, position, grid)
  end
end

class Pawn < Piece

  DELTA = [
    [-1, 1],
    [-1, 0],
    [-1,-1]
  ]

  attr_accessor :has_moved

  def initialize(color, position, current_board)
    super(color, position, current_board)
    @has_moved = false
  end

  def get_delta(start_pos, end_pos)
    x_delta = end_pos[0] - start_pos[0]
    y_delta = end_pos[1] - start_pos[1]
    [x_delta, y_delta]
  end

  def move(start_pos, end_pos)
#    debugger
    delta = self.class::DELTA
    delta += [[-2, 0]] unless has_moved?
    if color == :black
      delta = delta.map { |el| el.multiply_array([-1, 1]) }
    end

    delta.any? do |delta|
      current_board.valid_pawn_move?(start_pos, end_pos, delta)
    end

  end

  def moved
    self.has_moved = true
  end

  def has_moved?
    has_moved
  end

end
