# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  All_My_Pieces = All_Pieces + [rotations([[0,0],[-1,0],[1,0],[1,1],[0,1]]), #5 block, b like shape
                                [[[0,0],[-1,0],[1,0],[-2,0],[2,0]], # 5 block long
                                 [[0,0],[0,-1],[0,1],[0,-2],[0,2]]],
                                rotations([[0,0],[1,0],[0,1]])]
                           
  # your enhancements here
  def initialize(point_array, board)
    super(point_array, board)
  end

  def self.cheat_piece(board)
    MyPiece.new([[[0,0]]], board)
  end
  
  def self.next_piece(board)
    MyPiece.new(All_My_Pieces.sample, board)
  end
end

class MyBoard < Board
  # your enhancements here
  def initialize(game)
    super(game)
    @current_block = MyPiece.next_piece(self)
    @cheating = false
  end

  def next_piece
    if @cheating
        @current_block = MyPiece.cheat_piece(self)
        @cheating = false 
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(locations.size-1)).each{|index| 
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end

  def rotate_twice
    if !game_over? and @game.is_running?
      @current_block.move(0,0,2)
    end
    draw
  end

  def cheat
    if !game_over? and @game.is_running?
      if @score >= 100 and !@cheating
        @cheating = true
        @score -= 100
      end
    end
  end
end

class MyTetris < Tetris
  # your enhancements here
  def initialize
    super
  end

  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super
    @root.bind('u', proc {@board.rotate_twice})
    @root.bind('c', proc {@board.cheat})
  end          
end

