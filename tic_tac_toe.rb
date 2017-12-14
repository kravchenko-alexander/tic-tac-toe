require_relative 'player'
require_relative 'board'
require 'contracts'

# The class is the main game
#
class TicTacToe
  include Contracts::Core
  include Contracts::Builtin

  def initialize
    @board = Board.new

    @player_x = Player.new(name: 'Madame X', piece: :x, board: @board)
    @player_y = Player.new(name: 'Mister Y', piece: :y, board: @board)

    @current_player = @player_x
  end

  def play
    loop do
      @board.render
      @current_player.coordinates

      break if check_game_over

      switch_players
    end
  end

  Contract None => Bool
  def check_game_over
    check_victory || check_draw
  end

  Contract None => Bool
  def check_victory
    if @board.winning_combination?(@current_player.piece)
      puts "Congratulations #{@current_player.name}, you win!"
      true
    else
      false
    end
  end

  Contract None => Bool
  def check_draw
    if @board.full?
      puts "Bummer, you've drawn..."
      true
    else
      false
    end
  end

  Contract None => Player
  def switch_players
    @current_player = if @current_player == @player_x
                        @player_y
                      else
                        @player_x
                      end
  end
end
