require_relative 'board.rb'
require 'colorize'

class Game
  attr_reader :board 
  attr_accessor :color

  def initialize
    @board = Board.new
    @color = :white
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
      puts "Player's turn: #{color.to_s}"
      puts "CHECK" if board.in_check?(:black) || board.in_check?(:white)
      begin
        move = get_move
      rescue InvalidInputError
        puts "Enter valid coordinates (i.e., a1 through h8)"
        puts "re-enter all coordinates: "
        retry
      end
      begin
        board.make_move(move[0], move[1])
      rescue InvalidMoveError
        puts "That's an invalid move!"
        move = get_move
        retry
      end

      switch_colors!
    end
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


Game.new.play
