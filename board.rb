require 'contracts'

# Maintains game board state
class Board
  include Contracts::Core
  include Contracts::Builtin
  include Contracts::Invariants

  attr_reader :board

  invariant(:board) { board.nil? || board.is_a?(Array) && board.size == 3 }

  def initialize
    @board = Array.new(3) { Array.new(3) }
  end

  def render
    puts
    @board.each do |row|
      row.each do |cell|
        cell.nil? ? print('-') : print(cell.to_s)
      end
      puts
    end
    puts
  end

  Contract ->(x) { x.is_a?(Array) && x.size == 2 && x.all? { |e| (0..2).cover?(e) } }, Symbol => Bool
  def add_piece(coords, piece)
    if piece_location_valid?(coords)
      @board[coords[0]][coords[1]] = piece
      true
    else
      false
    end
  end

  Contract ->(x) { x.is_a?(Array) && x.size == 2 && x.all? { |e| (0..2).cover?(e) } } => Bool
  def piece_location_valid?(coords)
    coordinates_available?(coords)
  end

  Contract ->(x) { x.is_a?(Array) && x.size == 2 && x.all? { |e| (0..2).cover?(e) } } => Bool
  def coordinates_available?(coords)
    if @board[coords[0]][coords[1]].nil?
      true
    else
      puts 'There is already a piece there!'
      false
    end
  end

  Contract Symbol => Bool
  def winning_combination?(piece)
    winning_diagonal?(piece) ||
      winning_horizontal?(piece) ||
      winning_vertical?(piece)
  end

  Contract Symbol => Bool
  def winning_diagonal?(piece)
    diagonals.any? do |diag|
      diag.all? { |cell| cell == piece }
    end
  end

  Contract Symbol => Bool
  def winning_vertical?(piece)
    verticals.any? do |vert|
      vert.all? { |cell| cell == piece }
    end
  end

  Contract Symbol => Bool
  def winning_horizontal?(piece)
    horizontals.any? do |horz|
      horz.all? { |cell| cell == piece }
    end
  end

  Contract None => ->(x) { x.is_a?(Array) && x.size == 2 }
  def diagonals
    [[@board[0][0], @board[1][1], @board[2][2]],
     [@board[2][0], @board[1][1], @board[0][2]]]
  end

  Contract None => Array
  def verticals
    @board
  end

  Contract None => Array
  def horizontals
    horizontals = []
    3.times do |i|
      horizontals << [@board[0][i], @board[1][i], @board[2][i]]
    end
    horizontals
  end

  Contract None => Bool
  def full?
    @board.all? do |row|
      row.none?(&:nil?)
    end
  end
end
