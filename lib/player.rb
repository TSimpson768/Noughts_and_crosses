# frozen_string_literal: true

# Player represents an individual player, and a method for taking a turn
class Player
  # TODO
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  attr_reader :symbol, :name

  # Gets and returns chosen space in array from player
  # TODO; Guard aginst invalid input
  def take_turn
    puts "Pick a space, #{@name}"
    space = gets
    parse_input(space)
  end

  private

  # Takes a string input of a letter then a number, and returns the indices for the coresponding space in @board
  def parse_input(input)
    x_index = input[0].upcase.ord - 65
    y_index = input[1].to_i - 1
    unless (0..2).member?(x_index) && (0..2).member?(y_index)
      puts 'Invalid input'
      return take_turn
    end
    [x_index, y_index]
  end
end
