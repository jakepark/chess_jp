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
  attr_accessor :position, :current_board, :has_moved

  def initialize(color, position, current_board)
    @color = color
    @position = position
    @current_board = current_board
    @has_moved = false
  end

  CHESS_SYMBOLS = {
    #white
    "wp"=> "\u2659",
    "wh"=> "\u2658",
    "wb"=> "\u2657",
    "wr"=> "\u2656",
    "wq"=> "\u2655",
    "wk"=> "\u2654",

    #black
    "bp"=> "\u265F",
    "bh"=> "\u265E",
    "bb"=> "\u265D",
    "br"=> "\u265C",
    "bq"=> "\u265B",
    "bk"=> "\u265A",
  }

# puts checkmark.encode('utf-8')

  def inspect
    color = "#{self.color}"[0]
    name = "#{self.class}"[0].downcase

    letter = color + name
    CHESS_SYMBOLS[letter]
  end

  def icon
    color = "#{self.color}"[0]
    name = "#{self.class}"[0].downcase

    letter = color + name
    symbol = CHESS_SYMBOLS[letter].colorize(:black)
    #
    # if @color == :white
    #   symbol = symbol.colorize(:black)
    # else
    #   symbol = symbol.colorize(:black)
    # end
    # debugger
  end



  def piece_valid_move?(start_pos, end_pos)
    #essentially a dummy method, pawn has some conditons that must be passed
    #before throwing back to board
    current_board.valid_move?(start_pos, end_pos)
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

  def moved
    self.has_moved = true
  end

  def has_moved?
    has_moved
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

    self.class::DELTA.each do |deltoid|
      return deltoid if (1..1).to_a.any? do |multiple|
        multiple * deltoid[0] == x_delta &&
        multiple * deltoid[1] == y_delta
      end
    end

    nil
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

  def initialize(color, position, current_board)
    super(color, position, current_board)

  end

  def get_delta(start_pos, end_pos)
    x_delta = end_pos[0] - start_pos[0]
    y_delta = end_pos[1] - start_pos[1]
    [x_delta, y_delta]
  end

  def piece_valid_move?(start_pos, end_pos)
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

end
