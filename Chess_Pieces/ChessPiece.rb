class ChessPiece

  def initialize(is_white)
    @is_white = is_white
  end

  #@abstract methods
  def w; end
  def b; end

  # returns (false || nil || dest_box_piece)
  def can_move?(from, to, board)
    move_status = valid_move?(from, to)
    if !!move_status
      axis = get_axis(from, to)
      from_box_piece = board.get_box(axis[:x_from], axis[:y_from])
      dest_box_piece = board.get_box(axis[:x_to], axis[:y_to])

      if dest_box_piece != ChessPiece.blank
        unless dest_box_piece.white? and from_box_piece.white?
          if move_status.eql? "attack" #after pawn attack
            move_to from, to, board
            return dest_box_piece.to_s
          else
            return yield(from, to, board, dest_box_piece)
          end
        end
      elsif !move_status.eql? "attack"
        move_to from, to, board
        nil
      end
    end
    false
  end

  #defined methods
  # @param [ChessBoard] board
  def move_to(from, to, board)
    axis = get_axis from, to
    # @type [ChessPiece] prev
    prev = board.get_box axis[:x_from], axis[:y_from]
    board.set_box(axis[:x_to], axis[:y_to], prev)
    board.set_box axis[:x_from], axis[:y_from], ChessPiece.blank
  end

  def self.blank
    "___"
  end

  def white?
    @is_white
  end

  def set_white=(value)
    @is_white = value
  end

  def validate_pos(from, to)
    pos_regex = /^[a-h][1-8]$/i
    from =~ pos_regex && to =~ pos_regex
  end

  def valid_axis?(*coordinates)
    cord_range = 1..8
    coordinates.each do |axis|
      unless cord_range.include?(axis)
        return false
      end
    end
    true
  end

  def get_axis(from, to)
    x_axis_from = from[0].ord - 96
    y_axis_from = from[1].to_i
    x_axis_to = to[0].ord - 96
    y_axis_to = to[1].to_i
    { x_from: x_axis_from, y_from: y_axis_from, x_to: x_axis_to, y_to: y_axis_to }
  end

  def to_s
    @is_white ? w : b
  end
end