# frozen_string_literal: true

require_relative 'player'
require_relative 'piece'
require 'pry'

# Game represents the current state of the game.
# Board should probably be in its own class, but I can't be arsed refactoring this sphagetti
# any more than I have to to make it testable
class Game
  WINNING_LINES = [[[0,0],[1,0],[2,0]], [[0,1],[1,1],[2,1]], [[0,2],[1,2],[2,2]],
                   [[0,0],[0,1],[2,0]], [[1,0],[1,1],[2,1]], [[2,0],[2,1],[2,2]],
                   [[0,0],[1,1],[2,2]],  [[2, 0], [1,1], [0,2]]].freeze
  def initialize
    @board = initialize_board
    @player1 = Player.new('Player 1', 'X')
    @player2 = Player.new('Player 2', 'O')
    @players = [@player1, @player2]
    @current_player = @player1
  end

  # game loop that iterates over players until is_over? retutns true
  def play
    loop do
      print_board
      turn
      break if over?

      update_player
    end
    print_board
  end

  def update_player
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end
  end
  # puts a representation of the game board to console.
  def print_board
    puts '     |  A  |  B  |  C  |'
    @board.each_with_index do |line, y_index|
      puts '========================='
      puts "  #{y_index + 1}  #{render_line(line)}"
    end
    puts '========================='
  end

  

  # Returns true if either a player has won, or if a draw has occured. Puts the result
  def over?
    all_lines = return_winning_lines
    all_lines.any? { |line| three_in_a_row?(line) } || board_full?
  end

  def board_full?
    return false if @board.flatten.any?(&:nil?)

    puts 'Game over, no winner'
    true
  end

  # Player -> null Takes a user input and atempts to place relavent piece on board
  def turn
    loop do
      x_input, y_input = parse_input
      if valid_move?(x_input, y_input)
        @board[y_input][x_input] = @current_player.symbol
        break
      end
      puts 'That space is occupied!'
    end
  end

  def valid_move?(x_index, y_index)
    !@board[y_index][x_index]
  end

  # def parse_input(input)
  #   x_index = input[0].upcase.ord - 65
  #   y_index = input[1].to_i - 1
  #   unless (0..2).member?(x_index) && (0..2).member?(y_index)
  #     puts 'Invalid input'
  #     return take_turn
  #   end
  #   [x_index, y_index]
  # end

  def parse_input
    space_regex = /[A-Ca-c][1-3]/
    loop do
      input = gets.chomp
      if space_regex.match?(input)
        process_input(input)
        break
      end
      puts 'Invalid input'
    end
  end

  def process_input(input)
    x_index = input[0].upcase.ord - 65
    y_index = input[1].to_i - 1
    [x_index, y_index]
  end

  private

  def return_winning_lines
    WINNING_LINES.reduce([]) do |board_lines, line|
      winning_board_line = line.reduce([]) { |board_line, winning_space| board_line.push(@board[winning_space[1]][winning_space[0]]) }
      
      board_lines.push(winning_board_line)
    end    
  end
  # Returns true if all Pieces in a given array of 3 Pieces share a non - null owner
  def three_in_a_row?(row)
    return false unless row[0] && row[0] == row[1] && row[1] == row[2]

    puts "#{@current_player.name} has won!"
    true
  end

  # # Takes an array of columns in the board and a row, and maps the row to the columns
  # def row_to_columns(columns, row)
  #   row.each_with_index { |piece, index| columns[index].push(piece) }
  #   columns
  # end

  # def return_diagonals
  #   diagonals = [[], []]
  #   (0..2).each do |i|
  #     diagonals[0].push(@board[i][i])
  #     diagonals[1].push(@board[i][2 - i])
  #   end
  #   diagonals
  # end




  # Takes a array with 3 components, corresponding to a row on the board, and returns a string to render it to
  # the screen
  def render_line(row)
    line = row.reduce('') { |rendered_line, space| rendered_line + "|  #{space}  " }
    "#{line}|"
  end

  # Returns an array containing 3 arrays, each containing 3 Piece objects with no owner
  def initialize_board
    board = []
    3.times do
      row = []
      3.times do
        row.push(nil)
      end
      board.push(row)
    end
    board
  end
end
