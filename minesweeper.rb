# encoding: UTF-8
require 'debugger'#;debugger
class Minesweeper
  attr_accessor :board, :mask

  def initialize
  end

  def run
    mode = self.mode_select
    self.board = Board.new
    self.board.create_board_for_mode!(mode)
    # self.board.dev_display_board
    # self.board.display_board

    until won?
      do_turn
    end
  end

  def do_turn
    self.board.display_board
    move = get_move
    make_move(move)
  end

  def get_move
    input = ""
    until is_valid?(input)
      puts "Where would you like to move? '2 3 F' (row,col,action) [F for flag; P for probe]"
      input = gets.chomp.split(" ")
      input[0] = input[0].to_i
      input[1] = input[1].to_i
    end
  end

  def is_valid?(input)
    begin
      row = input[0]
      col = input[1]
      action = input[2]

      board_length = self.board.board.count
      if (action == "F" or action == 'P') and row.between?(0,board_length) and col.between?(0,board_length)
        return true
      end
    rescue
      return false
  end

  def make_move(move)
  end

  def mode_select
    input = 0
    until input.between?(1,2)
      puts  '1) beginner'
      puts  '2) intermediate'
      print 'what mode would you like to play? '
      input = gets.chomp.to_i
    end
    input
  end

end

class Board
  attr_accessor :board

  def create_board_for_mode!(mode)
    case mode
    when 1
      self.board = Array.new(9) { Array.new(9) {Square.new } }
      mines = (0..8).to_a.permutation(2).to_a.sample(10)
    when 2
      self.board = Array.new(16,) { Array.new(16) {Square.new } }
      mines = (0..15).to_a.permutation(2).to_a.sample(40)
    end

    mines.each do |mine|
      self.board[mine[0]][mine[1]].mine = true
    end

    number_the_squares!
  end

  def number_the_squares!
    0.upto(self.board.length-1) do |row|
      0.upto(self.board.length-1) do |col|
        mine_count = get_adj_mine_count(row,col)
        self.board[row][col].number = mine_count
      end
    end
  end

  def get_adj_mine_count(row,col)
    mine_count = 0
    [-1, 0, 1].each do |row_offset|
      [-1, 0, 1].each do |col_offset|
        if [row_offset, col_offset] != [0, 0] and space_on_board?(row + row_offset, col + col_offset)
          mine_count += 1 if self.board[row + row_offset][col + col_offset].mine
        end
      end
    end
    mine_count
  end

  def space_is_empty?(row, col)
    not self.board[row][col].mine
  end

  def space_on_board?(row, col)
    row.between?(0, self.board.length - 1) and col.between?(0, self.board.length - 1)
  end

  def dev_display_board
    puts " " + ("-" * (self.board.length * 4 - 1))
    self.board.each do |row|
      print '|'
      row.each do |square|
        if square.mine
          print ' ▓ |'
        elsif square.number == 0
          print '   |'
        else
          print " #{square.number} |"
        end
      end
      puts ''
    puts " " + ("-" * (self.board.length * 4 - 1))
    end
  end

  def display_board
    puts " " + ("-" * (self.board.length * 4 - 1))
    self.board.each do |row|
      print '|'
      row.each do |square|
        if square.visible
          if square.mine
            print ' ▓ |'
          elsif square.number == 0
            print '   |'
          else
            print " #{square.number} |"
          end
        else
          if square.flagged
            print ' ⚑ |'
          elsif
            print '   |'
          end
        end
      end
      puts ''
      puts " " + ("-" * (self.board.length * 4 - 1))
    end
  end

end

class Square
  attr_accessor :visible, :flagged, :mine, :number

  def initialize
    self.visible = false
    self.flagged = false
    self.mine = false
    self.number = 0
  end

end

m = Minesweeper.new.run