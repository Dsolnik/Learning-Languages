require_relative 'Board'
require_relative 'Piece'
require_relative 'Knight'
require_relative 'Castle'
require_relative 'Pawn'
require_relative 'Bishop'
require_relative 'Queen'
require_relative 'King'
class Chess_Game
	
	attr_accessor :player1, :player2, :board
	
	def initialize (name1, name2)
		@player1 = name1
		@player2 = name2
	end

	def start_game
		puts @board ? "Game is already underway" : "Game started"
		unless @board
			@board = Board.new
			@board.output_board 
		end
	end

	def end_game
		if @board
			@board = nil
			puts "Game ended"
		else
			puts "No game is underway"
		end
	end

	def castle(team, coordinate)
		pieces_not_nil = @board.pieces.values.select{ |val| val!=nil }
		king = pieces_not_nil.select { |val| val.name == "King" && val.team == team }
		#Castle left
		if coordinate[0] < 3
			#get the castle on the same team in the first column
			castle = pieces_not_nil.select { |val| val.name == "Castle" && val.xCord == 0 && val.team == team }
			@board.move_piece(castle, [3, castle.yCord], true)
			@board.move_piece(king, [2, castle.yCord], true)
		#Castle right
		else
			castle = pieces_not_nil.select { |val| val.name == "Castle" && val.xCord == 7 && val.team == team }
			@board.move_piece(castle, [5, castle.yCord], true)
			@board.move_piece(king, [6, castle.yCord], true)
		end
	end

	def check_castle(team, coordinate)
		pieces_not_nil = @board.pieces.values.select{ |val| val!=nil }
		king = pieces_not_nil.select { |val| val.name == "King" && val.team == team }
		#Castle left
		if coordinate[0] == 2
			#get the castle on the same team in the first column
			castle = pieces_not_nil.select { |val| val.name == "Castle" && val.xCord == 0 && val.team == team }
			#check that castle hasn't moved and that the 3 adjacent squares are empty
			if !castle.has_moved && !@board.pieces[[1, castle.yCord]] && !@board.pieces[[2, castle.yCord]] && !@board.pieces[[3, castle.yCord]]
				return true
			end
		#Castle Right
		elsif coordinate[0] == 6
			#get the king on the same team in the first column
			castle = pieces_not_nil.select { |val| val.name == "Castle" && val.xCord == 7 && val.team == team }
			#check that castle hasn't moved and that the 2 adjacent squares are empty
			if !castle.has_moved && !@board.pieces[[6, castle.yCord]] && !@board.pieces[[5, castle.yCord]]
				return true
			end
		end
		return false
	end

	#returns true if moved piece, false if not
	def move_piece(piece_name, team, coordinate)
		pieces = @board.get_pieces(piece_name, team)
		can_move = []
		pieces.each do |piece|
			can_move << piece if @board.can_move?(piece, coordinate)
		end
		#CHECK CASTLING
		if piece_name == "King"
			unless pieces[0].has_moved 
				if check_castle(team, coordinate)
					castle(team, coordinate)
					return true
				end
			end
		end
		#if there are no pieces on that team that can move there, return false
		if can_move.length == 0
			#puts "RETURNING FALSE!1"
			return false
		#if there are more than 1 piece list all of the pieces and give the option to choose
		elsif can_move.length >1
			goodInput = false
			until goodInput == true
				puts "Which of the following pieces would you like to move?"
				can_move.each_with_index do |piece, index|
					puts "#{index + 1} : #{piece.name} at [#{piece.xCord},#{piece.yCord}]"
				end
				puts "Alternatively, enter -1 to quit out of this selection and invalidate the move."
				index = gets.chomp.to_i - 1
				return false if index == -2 
				goodInput = true if @board.move_piece(can_move[index], coordinate)
				puts "Incorrect input!" unless goodInput
			end
			#puts "RETURNING TRUE!2"			
			return true
		#if there's one piece, call the move method
		elsif can_move.length == 1
			moved = @board.move_piece(can_move[0], coordinate)
			#puts "RETURNING TRUE!3" if moved
			#puts "RETURNING FALSE!3" if !moved
			return moved
		end
		return false
	end

	#returns nil if no checkmate or name of player that won if there is checkmate
	def checkmate?
		return @name2 if @board.checkmate?(@board.pieces, 1)
		return @name1 if @board.checkmate?(@board.pieces, 2)
		nil
	end

	def stalemate?
		pieces_not_nil = @board.pieces.values.select{ |val| val!=nil }
		team1players = pieces_not_nil.select { |val| val.team == 1}
		team1 = true if team1players.length == 1
		if team1
			return false unless @board.get_pieces("King", 1)[0].is_in_checkmate?(@board.pieces)
		else
			team2players = pieces_not_nil.select { |val| val.team == 2}
			return false unless team2players.length == 1
			return false unless @board.get_pieces("King", 2)[0].is_in_checkmate?(@board.pieces)			
		end
		true
	end

end


puts "Welcome to Chess!"
puts "What is the name of Player1?"
name1 = gets.chomp
puts "What is the name of Player2?"
name2 = gets.chomp
game = Chess_Game.new(name1, name2)
game.start_game
play1turn = true
move_number = 0
while(true)
	name = play1turn ? name1 : name2
	turn = play1turn ? 1 : 2 
	moved = false
	move_number += 1
	if game.checkmate?
		puts "Congratulations! " + game.checkmate? + ", you have won!"
		exit
	elsif game.stalemate?
		puts "The game ended in a tie!"
		exit
	end
	puts "Move # #{move_number}"
	until moved 
		print "Enter EXIT to exit:"
		x = gets.chomp
		exit if x == "EXIT"
		in_check = false
		puts "It's " + name + "'s turn!\nYou are player #" + turn.to_s
		piece_to_move, x, y = nil, nil, nil
		valid_input = false
		until valid_input
			puts "What piece would you like to move? Your choices are: Knight, Castle, Bishop, King, Queen, Horse or Pawn"
			piece_to_move = gets.chomp
			valid_input = true if piece_to_move == "Knight" || piece_to_move == "Horse" || piece_to_move == "Castle" || piece_to_move == "Bishop" || piece_to_move == "King" || piece_to_move == "Queen" ||  piece_to_move == "Pawn"
		end
		piece_to_move = "Knight" if piece_to_move == "Horse"
		valid_input = false
		until valid_input
			puts "What x coordinate would you like to move it to?"
			x = gets.chomp.to_i
			valid_input = true if x < 8 && x >= 0 
		end
		valid_input = false
		until valid_input
			puts "What y coordinate would you like to move it to?"
			y = gets.chomp.to_i
			valid_input = true if x < 8 && x >= 0 
		end
		success = game.move_piece(piece_to_move, turn, [x, y])
		if success
			moved = true
			play1turn = !play1turn
		end
		game.board.output_board
	end
end
