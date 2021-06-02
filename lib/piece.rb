# frozen_string_literal: true

require_relative 'player'
# Represents an individual nought or cross on the board
class Piece
  def initialize; end

  def owner=(player)
    @owner ||= player
  end
  attr_reader :owner

  # Returns a string representation of the piece
  def render
    if @owner
      owner.symbol
    else
      ' '
    end
  end
end
