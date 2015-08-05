require_relative 'board.rb'
require 'colorize'

class Game
  attr_reader :board
  attr_accessor :color, :saved_grid, :error_message

  def initialize
    @board = Board.new
    @color = :white
    @saved_grid = nil
    @error_message = ""
  end

  COL_HASH = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7
  }

  ROW_HASH = {
    "1" => 7,
    "2" => 6,
    "3" => 5,
    "4" => 4,
    "5" => 3,
    "6" => 2,
    "7" => 1,
    "8" => 0
  }

  def play

    loop do
      system "clear"
      board.render
      display_turn
      in_check?
      puts error_message
      move = get_coordinates
      check_color(move)
      check_validity(move)
      check_check
      switch_colors!
      self.error_message = ""
    end
  end

  def check_color?(move)
    if board[move[0]].color != color
      puts "Invalid color!"
      raise InvalidColorError
    end
  end

  def check_color(move)
    begin
      check_color?(move)
    rescue InvalidColorError
      self.error_message = "That's not yours!! Select your own piece."
      play
      retry
    end
  end

  def check_check
    begin
      still_in_check?
    rescue StillInCheckError
      self.board.grid = saved_grid
      self.error_message = "That move leaves you in Czech. Live less dangerously."
      play
    end
  end

  def still_in_check?
    if board.in_check?(color)
      raise StillInCheckError
    end
  end

  def color_error
    begin
    play
    rescue InvalidColorError

      self.error_message = "You must move your own piece!"
      retry
    end
  end

  def display_turn
    puts "Player's turn: #{color.to_s}"
  end

  def get_coordinates
    begin
      move = get_move
    rescue InvalidInputError
      self.error_message = "Enter valid coordinates (i.e., a1 through h8) \nre-enter all coordinates: "
      play
    end
  end

  def check_validity(move)
    begin
      self.saved_grid = board.grid.deep_dup
      board.make_move(move[0], move[1])
    rescue InvalidMoveError
      self.error_message = "That's an invalid move!"
      play
      retry
    end
  end

  def in_check?
    puts "CHECK!" if board.in_check?(:black) || board.in_check?(:white)
  end

  def switch_colors!
    self.color == :white ? self.color = :black : self.color = :white
  end

  def get_move
    begin
      puts "initial coordinates"
      print (">>>").colorize(:background => :green)
      start = gets.chomp.split("")
      unless start[0].between?("a", "h") && start[1..-1].join.between?("1", "8")
        raise InvalidInputError.new
      end
      start = [ROW_HASH[start[1]], COL_HASH[start[0]]]

      puts "end coordinates"
      print ">  "
      ending = gets.chomp.split("")
      unless ending[0].between?("a", "h") && ending[1..-1].join.between?("1", "8")
        raise InvalidInputError.new
      end
      ending = [ROW_HASH[ending[1]], COL_HASH[ending[0]]]

      [start, ending]
    end

  end



end

class InvalidMoveError < StandardError
end

class InvalidInputError < StandardError
end

class InvalidColorError < StandardError
end

class StillInCheckError < StandardError
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

Game.new.play
