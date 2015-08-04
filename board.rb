require_relative 'pieces.rb'

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
          self[pos] = Knight.new(:white, pos, self)
        elsif row_idx == 7 && col_idx == 1
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

  def valid_move?(start_pos, end_pos, piece_delta)

    start_pos[0] + piece_delta[0] == end_pos[0] &&
    start_pos[1] + piece_delta[1] == end_pos[1] &&
    (self[end_pos].nil? || (self[end_pos].color != self[start_pos].color))

    #   self[end_pos].color != self[start_pos].color
    # end
  end

end
