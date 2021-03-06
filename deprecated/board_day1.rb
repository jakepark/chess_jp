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
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        pos = [row_idx, col_idx]
        if row_idx == 6 && col_idx == 3
          self[pos] = Bishop.new(:white, pos, self)
        elsif row_idx == 4 && col_idx == 5
          self[pos] = Ting.new(:black, pos, self)
        elsif row_idx == 3 && col_idx == 3
          self[pos] = Knight.new(:white, pos, self)
        end
     end
   end

  end

  def on_board?(pos)
    [pos[0], pos[1]].all? { |el| el.between?(0, 8) }
  end

  def make_move(start_pos, end_pos)
    if self[start_pos].move(start_pos, end_pos)
      self[end_pos] = self[start_pos]
      self[start_pos] = nil
    end
  end

  def valid_move?(start_pos, end_pos)
    #debugger
    original_delta = self[start_pos].get_delta(start_pos, end_pos)
    delta = [0, 0]
    until start_pos.add_arrays(delta).add_arrays(original_delta) == end_pos
      delta = delta.add_arrays(original_delta)
      return false unless self[start_pos.add_arrays(delta)].nil?
    end

    unless (self[end_pos].nil? || (self[end_pos].color != self[start_pos].color))
      return false
    end

    true
  end

end
