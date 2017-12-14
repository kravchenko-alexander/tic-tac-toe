require_relative 'board'
require 'contracts'

# Manages all player-related functionality
class Player
  include Contracts::Core
  include Contracts::Builtin
  include Contracts::Invariants

  attr_accessor :name, :piece

  invariant(:name) { name.is_a?(String) }
  invariant(:piece) { piece.is_a?(Symbol) && %i[x y].include?(piece) }

  Contract ({ name: String, piece: Symbol, board: Board }) => Any
  def initialize(name: 'Mystery_Player', piece:, board:)
    raise 'Piece must be a Symbol!' unless piece.is_a?(Symbol)
    @name = name
    @piece = piece
    @board = board
  end

  def coordinates
    loop do
      coords = ask_for_coordinates

      next unless @board.add_piece(coords, @piece)
      break
    end
  end

  Contract None => ArrayOf[Num]
  def ask_for_coordinates
    puts "#{@name}(#{@piece}), enter your coordinates in the form x,y:"
    gets.strip.split(',').map(&:to_i)
  end
end
