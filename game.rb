require_relative 'board.rb'
require 'colorize'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def play
    loop do
      board.render
      #debugger
      move = get_move
      board.make_move(move[0], move[1])
      sleep(1)
      system "clear"
      board.render
    end
  end

  def get_move
    puts "inital coordinates"
    start = gets.chomp.split(",").map(&:to_i)
    puts "end coordinates"
    ending = gets.chomp.split(",").map(&:to_i)
    [start, ending]
  end
end

Game.new.play
