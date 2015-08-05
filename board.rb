require_relative 'pieces.rb'
require 'byebug'
require 'colorize'

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

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) {Array.new(8)}
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
    # grid.each_with_index do |row, row_idx|
    #   row.each_with_index do |col, col_idx|
    #     pos = [row_idx, col_idx]
    #     if row_idx == 6 && col_idx == 3
    #       self[pos] = Bishop.new(:white, pos, self)
    #     elsif row_idx == 4 && col_idx == 5
    #       self[pos] = King.new(:black, pos, self)
    #     elsif row_idx == 3 && col_idx == 3
    #       self[pos] = Horse.new(:white, pos, self)
    #     end
    #  end
    populate_white_pieces
    populate_black_pieces
   end

   def populate_white_pieces
     self[[7, 7]], self[[7, 0]] = Rook.new(:white, [7,7], self), Rook.new(:white, [7,0], self)
     self[[7, 6]], self[[7, 1]] = Horse.new(:white, [7,6], self), Horse.new(:white, [7,1], self)
     self[[7, 5]], self[[7, 2]] = Bishop.new(:white, [7,5], self), Bishop.new(:white, [7,2], self)
     self[[7, 3]] = Queen.new(:white, [7,3], self)
     self[[7, 4]] = King.new(:white, [7,4], self)
     grid[6].each_index { |idx| grid[6][idx] = Pawn.new(:white, [6,idx], self) }

    #  grid[6].map! { |el| el = Pawn.new(:white, nil, self) }
   end

   def populate_black_pieces
     self[[0, 7]], self[[0, 0]] = Rook.new(:black, [0,7], self), Rook.new(:black, [0,0], self)
     self[[0, 6]], self[[0, 1]] = Horse.new(:black, [0,6], self), Horse.new(:black, [0,1], self)
     self[[0, 5]], self[[0, 2]] = Bishop.new(:black, [0,5], self), Bishop.new(:black, [0,2], self)
     self[[0, 3]] = Queen.new(:black, [0,3], self)
     #self[[0, 4]] = King.new(:black, [0,4], self)
     self[[5, 4]] = King.new(:black, [5,4], self)
     grid[1].each_index { |idx| grid[1][idx] = Pawn.new(:black, [1,idx], self) }

    #  grid[1].map! { |el| el = Pawn.new(:black, nil, self) }
   end


  def on_board?(pos)
    [pos[0], pos[1]].all? { |el| el.between?(0, 8) }
  end

  def make_move(start_pos, end_pos)
    if self[start_pos].move(start_pos, end_pos)
      self[start_pos].moved
      self[start_pos].position = end_pos
      self[end_pos] = self[start_pos]
      self[start_pos] = nil
    end
  end

  def in_check?(color)
    king_pos = find_king(color)
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |el, col_idx|
        if !el.nil? && el.color != color
            return true if el.move(el.position, king_pos)
        end
      end
    end
    false
  end

  def find_king(color)
    king_pos = []

    grid.each_with_index do |row, row_idx|
      row.each_with_index do |el, col_idx|
        if el.class == King && el.color == color
          king_pos = [row_idx, col_idx]
        end
      end
    end

    king_pos
  end

  def valid_move?(start_pos, end_pos)

    original_delta = self[start_pos].get_delta(start_pos, end_pos)
    delta = [0, 0]
    return false if original_delta.nil?
    until start_pos.add_arrays(delta).add_arrays(original_delta) == end_pos
      delta = delta.add_arrays(original_delta)
      return false unless self[start_pos.add_arrays(delta)].nil?
    end

    unless (self[end_pos].nil? || (self[end_pos].color != self[start_pos].color))
      return false
    end

    true
  end

  def valid_pawn_move?(start_pos, end_pos, delta)

    if delta == self[start_pos].get_delta(start_pos, end_pos)
      if delta.first.abs == delta.last.abs
        if !self[end_pos].nil? && self[end_pos].color != self[start_pos].color
          return true
        end
      else
       if self[end_pos].nil?
         return true
       end
      end
    end

    false
  end

  def render
#    ("a".."h").to_a.each{|x| print "   #{x}  "}
    ("a".."h").to_a.each{|x| print " #{x} "}
    #print "---------------------------------"
    print "\n"
    @grid.each_with_index do |row, idx|
      row.each_with_index do |col, idy|
        black_grid = (idx + idy) % 2 == 0
        if col.nil?
          if black_grid
            print "   "
          else
            print "   ".colorize(:background => :white)
          end
        else
          if black_grid
            print " #{col.icon} "
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
    nil
  end
end
