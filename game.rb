require_relative 'board.rb'
require 'colorize'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
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
      board.render
      puts "CHECK" if board.in_check?(:black) || board.in_check?(:white)
      move = get_move
      board.make_move(move[0], move[1])
      sleep(1)
      system "clear"
      board.render
      #puts "CHECK" if board.in_check?(:black) || board.in_check?(:white)
    end
  end

  def get_move
    puts "inital coordinates"
    start = gets.chomp.split("")
    start = [ROW_HASH[start[1]], COL_HASH[start[0]]]
    puts "end coordinates"
    ending = gets.chomp.split("")
    ending = [ROW_HASH[ending[1]], COL_HASH[ending[0]]]
    [start, ending]
  end
end

Game.new.play
