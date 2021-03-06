require_relative 'pieces.rb'
require 'byebug'
require 'colorize'

class Board
  attr_accessor :grid, :saved_grid

  def initialize
    @grid = Array.new(8) {Array.new(8)}
    @saved_grid = nil
    populate
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, val)
    x, y = pos
    grid[x][y] = val
  end

  def populate
    populate_white_pieces
    populate_black_pieces
  end

  def on_board?(pos)
    [pos[0], pos[1]].all? { |el| el.between?(0, 8) }
  end


  # unless self[start_pos].piece_valid_move?(start_pos, end_pos)
  #   raise ArgumentError.new
  # end

  # def make_move(start_pos, end_pos)
  #   if self[start_pos].piece_valid_move?(start_pos, end_pos)
  #     self[start_pos].moved
  #     self[start_pos].position = end_pos
  #     self[end_pos] = self[start_pos]
  #     self[start_pos] = nil
  #   end
  # end
  def piece_color(pos)
    self[pos].color
  end

  def make_move(start_pos, end_pos)
    unless self[start_pos].piece_valid_move?(start_pos, end_pos)
      raise InvalidMoveError.new
    end
      self[start_pos].moved
      self[start_pos].position = end_pos
      self[end_pos] = self[start_pos]
      self[start_pos] = nil
#    end
  end

  def valid_move?(start_pos, end_pos)
    vector = move_vector(start_pos, end_pos)
    delta = [0, 0]

    return false if vector.nil?

    until incremented_pos(start_pos, delta) == penultimate_pos(end_pos, vector)
      delta = delta.add_arrays(vector)
      return false unless self[incremented_pos(start_pos, delta)].nil?
    end

    return false unless valid_square?(start_pos, end_pos)

    true
  end

  def valid_pawn_move?(start_pos, end_pos, delta)

    if valid_pawn_vector?(start_pos, end_pos, delta)
      if pawn_capture?(delta)
        return true if valid_pawn_capture?(start_pos, end_pos)
      else
       if empty_square?(end_pos)
         return true
       end
      end
    end

    false
  end

  def in_check?(color)
    king_pos = find_king(color)

    grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx| #should piece be "square_contents"?
        if !piece.nil? && piece.color != color
          return true if piece.piece_valid_move?(piece.position, king_pos)
        end
      end
    end

    false
  end

  def find_king(color)
    king_pos = []

    grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx|
        king_pos = [row_idx, col_idx] if friendly_king?(piece, color)
      end
    end

    king_pos
  end

  def render
#    ("a".."h").to_a.each{|x| print "   #{x}  "}
    print "   "
    ("a".."h").to_a.each{|x| print " #{x} "}
    #print "---------------------------------"
    print "\n"
    grid.each_with_index do |row, idx|
        print " #{8 - idx} "
      row.each_with_index do |col, idy|

        black_grid = (idx + idy) % 2 == 0
        if col.nil?
          if black_grid
            print "   ".colorize(:background => :blue)
          else
            print "   ".colorize(:background => :white)
          end
        else
          if black_grid
            print " #{col.icon} ".colorize(:background => :blue)
          else
            print " #{col.icon} ".colorize(:background => :white)
          end
        end
      end
        print " #{8 - idx}"
        print "\n"

    #    print "---------------------------------"
      #  print "\n"
    end
    print "   "
    ("a".."h").to_a.each{|x| print " #{x} "}
    print "\n"
    nil
  end

  # def find_pieces(color)
  #   pieces = []
  #
  #   grid.each_with_index do |row, row_idx|
  #     row.each_with_index do |piece, col_idx|
  #       pieces << [row_idx, col_idx] if friendly_piece?(piece, color)
  #     end
  #   end
  #
  #   pieces
  # end
  #
  # def friendly_piece?(piece, color)
  #   !piece.nil? && piece.color == color
  # end
  #
  # def check_mate?(color)
  #   #debugger
  #   self.saved_grid = grid.deep_dup
  #   pieces = find_pieces(color)
  #   pieces.each do |piece|
  #     self.grid = saved_grid.deep_dup
  #     grid.each_with_index do |row, row_idx|
  #       row.each_index do |col_idx|
  #         #debugger
  #         end_pos = [row_idx, col_idx]
  #
  #         if self[piece].piece_valid_move?(piece, end_pos)
  #           make_move(piece, end_pos)
  #           #debugger
  #           if in_check?(self[piece].color)
  #             self.grid = saved_grid.deep_dup
  #           else
  #             return false
  #           end
  #         else
  #           self.grid = saved_grid.deep_dup
  #           next
  #         end
  #       end
  #     end
  #   end
  #   true
  # end

  private

  def friendly_king?(piece, color)
    piece.class == King && piece.color == color
  end

  def empty_square?(pos)
    self[pos].nil?
  end

  def unfriendly_fire?(start_pos, end_pos)
    self[end_pos].color != self[start_pos].color
  end

  def move_vector(start_pos, end_pos)
     self[start_pos].get_delta(start_pos, end_pos)
   end

  def penultimate_pos(pos, move_vector)
    pos.subtract_arrays(move_vector)
  end

  def incremented_pos(pos, delta)
    pos.add_arrays(delta)
  end

  def valid_square?(start_pos, end_pos)
    #not occupied by piece with same colot
    empty_square?(end_pos) || unfriendly_fire?(start_pos, end_pos)
  end

  def pawn_capture?(delta)
    delta.first.abs == delta.last.abs
  end

  def valid_pawn_capture?(start_pos, end_pos)
    !empty_square?(end_pos) && unfriendly_fire?(start_pos, end_pos)
  end

  def valid_pawn_vector?(start_pos, end_pos, delta)
    delta == move_vector(start_pos, end_pos)
  end

 #forgive us
   def populate_white_pieces
     self[[7, 7]], self[[7, 0]] = Rook.new(:white, [7,7], self), Rook.new(:white, [7,0], self)
     self[[7, 6]], self[[7, 1]] = Horse.new(:white, [7,6], self), Horse.new(:white, [7,1], self)
     self[[7, 5]], self[[7, 2]] = Bishop.new(:white, [7,5], self), Bishop.new(:white, [7,2], self)
     self[[7, 3]] = Queen.new(:white, [7,3], self)
     self[[7, 4]] = King.new(:white, [7,4], self)
     grid[6].each_index { |idx| grid[6][idx] = Pawn.new(:white, [6,idx], self) }
   end

   def populate_black_pieces
     self[[0, 7]], self[[0, 0]] = Rook.new(:black, [0,7], self), Rook.new(:black, [0,0], self)
     self[[0, 6]], self[[0, 1]] = Horse.new(:black, [0,6], self), Horse.new(:black, [0,1], self)
     self[[0, 5]], self[[0, 2]] = Bishop.new(:black, [0,5], self), Bishop.new(:black, [0,2], self)
     self[[0, 3]] = Queen.new(:black, [0,3], self)
     self[[0, 4]] = King.new(:black, [0,4], self)
     #self[[5, 4]] = King.new(:black, [5,4], self)
     grid[1].each_index { |idx| grid[1][idx] = Pawn.new(:black, [1,idx], self) }
   end
end

class Array
  def add_arrays(other_array)
    summed_array = []
    self.each_index { |idx| summed_array << (self[idx] + other_array[idx]) }
    summed_array
  end

  def subtract_arrays(other_array)
    summed_array = []
    self.each_index { |idx| summed_array << (self[idx] - other_array[idx]) }
    summed_array
  end

  def multiply_array(other_array)
    product_array = []
    self.each_index{|idx| product_array << (self[idx] * other_array[idx]) }
    product_array
  end
end

class Array

  def deep_dup
    self.map do |el|
      if el.is_a?(Array)
        el.dup.deep_dup
      else
        el
      end
    end
  end

end
