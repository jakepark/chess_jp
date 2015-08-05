def find_pieces(color)
  pieces = []

  grid.each_with_index do |row, row_idx|
    row.each_with_index do |piece, col_idx|
      pieces << [row_idx, col_idx] if friendly_piece?(piece, color)
    end
  end

  pieces
end

def friendly_piece?(piece, color)
  !piece.nil? && piece.color == color
end

self.saved_grid = board.grid.deep_dup  # save state

#Board
pieces.each do |piece|
  grid.each_index do |row_idx|
    row.each_index do |col_idx|
      end_pos = board[row_idx, col_idx]
      if piece_valid_move?(piece.pos, end_pos)
        make_move(piece.pos, end_pos)
        if in_check?(piece.color)
          self.grid = saved_grid
        else
          return false
        end

      else
        next
      end

    end
  end
  true
end
