require_relative 'Player'
require_relative 'ConsoleInterface'
require_relative 'ChessBoard'
require_relative 'ManageGame'
#get all chess pieces
require_relative 'Chess_Pieces/ChessPiece'
require_relative 'Chess_Pieces/Pawn'
require_relative 'Chess_Pieces/Bishop'
require_relative 'Chess_Pieces/Rook'
require_relative 'Chess_Pieces/King'
require_relative 'Chess_Pieces/Queen'
require_relative 'Chess_Pieces/Knight'

class Chess

  def initialize(white_player_name, black_player_name)
    #Player Class objects
    @white_player = Player.new(white_player_name, true)
    @black_player = Player.new(black_player_name, false)
    @console = ConsoleInterface.new
    @board = ChessBoard.new
    @load_game = ManageGame.new
  end

  #move_string ( e.g. p=e2:e4 )
  def move_piece(move_string, player_name, is_first_turn = false)
    if move_string =~ /^\s*[prnbqk]\s*=\s*[a-h][1-8]\s*:\s*[a-h][1-8]$/i
      #input is valid now
      piece_positions = move_string.split("=")
      prev_new_pos = piece_positions[1].split(":")

      #get piece color to move
      if @white_player.to_s.eql? player_name
        piece_to_move = ChessPiece.new @white_player.white?
      elsif @black_player.to_s.eql? player_name
        piece_to_move = ChessPiece.new @black_player.white?
      else
        raise ArgumentError, "(!) Player Name is invalid"
      end

      is_pawn = false   # checks if pawn is the piece to move

      # get the piece to move
      case piece_positions[0].downcase
      when 'p'
        pawn_move = Pawn.new piece_to_move.white?
        is_pawn = true
      when 'r'
        piece_to_move = Rook.new piece_to_move.white?
      when 'n'
        piece_to_move = Knight.new piece_to_move.white?
      when 'b'
        piece_to_move = Bishop.new piece_to_move.white?
      when 'q'
        piece_to_move = Queen.new piece_to_move.white?
      when 'k'
        piece_to_move = King.new piece_to_move.white?
      else
        raise ArgumentError, "(!) Move should match given format"
      end

      #start moving piece
      if is_pawn
        move_status = pawn_move.can_move? prev_new_pos[0], prev_new_pos[1], @board, is_first_turn
      else
        move_status = piece_to_move.can_move? prev_new_pos[0], prev_new_pos[1], @board
      end

    else raise ArgumentError, "(!) Move should match given format"; end
  end

  def flip_board
    @board.reverse_board
  end

  def save_game(game_name)
    @load_game.export_game game_name, get_players, @board
  end

  def delete_game(game_name)
    @load_game.delete_game_file game_name
  end

  def reset_game
    @board = ChessBoard.new
    player1_name = @white_player.to_s
    player2_name = @black_player.to_s
    @white_player = Player.new player1_name, true
    @black_player = Player.new player2_name, false
    @console = ConsoleInterface.new
  end

  def get_players
    [@white_player, @black_player]
  end

  def eliminate_player(player_name)
    if @white_player.to_s === player_name
      @white_player.eliminate
    elsif @black_player.to_s === player_name
      @black_player.eliminate
    end
  end

  def show_console(player)
    @console.display_board @board
    @console.show_menu player
  end

end
