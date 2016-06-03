class Board
	attr_accessor :pieces

	def initialize
		@pieces = Hash.new()
		for i in 0..7
			for j in 0..7
				@pieces[[i, j]] = nil
			end
		end
		initialize_pieces
	end

	def initialize_pieces
		#pawns
		for i in 0..7
			add_piece(Pawn.new(1, self, i, 1))
			add_piece(Pawn.new(2, self, i, 6))
		end
		#Castles
		add_piece(Castle.new(1, self, 0, 0))
		add_piece(Castle.new(1, self, 7, 0))
		add_piece(Castle.new(2, self, 0, 7))
		add_piece(Castle.new(2, self, 7, 7))
		#Knights
		add_piece(Knight.new(1, self, 1, 0))
		add_piece(Knight.new(1, self, 6, 0))
		add_piece(Knight.new(2, self, 1, 7))
		add_piece(Knight.new(2, self, 6, 7))
		#Bishops
		add_piece(Bishop.new(1, self, 2, 0))
		add_piece(Bishop.new(1, self, 5, 0))
		add_piece(Bishop.new(2, self, 2, 7))
		add_piece(Bishop.new(2, self, 5, 7))
		#Queens
		add_piece(Queen.new(1, self, 3, 0))
		add_piece(Queen.new(2, self, 3, 7))
		#Kings
		add_piece(King.new(1, self, 4, 0))
		add_piece(King.new(2, self, 4, 7))
	end

	def add_piece(piece)
		coordinate = [piece.xCord, piece.yCord]
		@pieces[coordinate] = piece
	end

	#returns true if it moved or false if the coordinate isn't on board or the piece isn't allowed to move there
	#because of the rules of movement of the piece or it would be in check
	#input:
	# => piece: object
	# => coordinate: [xCord, yCord]
	def move_piece(piece, coordinate, override = nil)
		unless override
			#check if desired coordinate is on board
			return false unless piece.check_on_board?(coordinate[0], coordinate[1])
			#move piece to new coordinates and set old coordinate in @pieces to nil
			return false unless can_move?(piece, coordinate)
			piece.has_moved = true if piece.name == "King" || piece.name == "Castle"
			old_coordinate = [piece.xCord, piece.yCord]
			piece.xCord, piece.yCord = coordinate
			@pieces[coordinate] = piece
			@pieces[old_coordinate] = nil
			return true
		else
			piece.has_moved = true if piece.name == "King" || piece.name == "Castle"
			old_coordinate = [piece.xCord, piece.yCord]
			piece.xCord, piece.yCord = coordinate
			@pieces[coordinate] = piece
			@pieces[old_coordinate] = nil
		end
	end

	def can_move?(piece, coordinate)
		total_moves = piece.get_moves(@pieces) + piece.take_moves(@pieces)
		return false unless total_moves.include?(coordinate)
		clone_pieces = @pieces.clone
		clone_piece = piece.clone
		#replace piece with clone of piece 
		clone_pieces[[clone_piece.xCord, clone_piece.yCord]] = clone_piece
		#move piece on new_pieces
		old_coordinate = [clone_piece.xCord, clone_piece.yCord]
		clone_piece.xCord, clone_piece.yCord = coordinate
		clone_pieces[coordinate] = piece
		clone_pieces[old_coordinate] = nil
		#check if it's checkmate on new board
		return !checkmate?(clone_pieces, clone_piece.team)
		#if it's checkmate, return false, if not return true
	end

	#returns true if this king is in checkmate
	def checkmate?(pieces, team)
		pieces_not_nil = pieces.values.select{ |val| val!=nil }
		king = pieces_not_nil.select { |val| val.name == "King" && val.team == team }[0]	
		return true if king.is_in_checkmate?(pieces)
		false
	end

	#returns array of pieces of selected thingy
	def get_pieces(name, team)
		pieces_not_nil = @pieces.values.select{ |val| val!=nil }
		a = pieces_not_nil.select { |val| val.name == name && val.team == team }
	end

	def output_board
		puts "-------------------------------------------"
		7.downto(0) do |i|
			print "#{i} |"
			for j in 0..7
				if @pieces[[j, i]]
					print " "
					print_symbol(@pieces[[j, i]].name, @pieces[[j, i]].team)
					#print @pieces[[j, i]].name[0] unless @pieces[[j, i]].name == "Knight"
					#print "H" if @pieces[[j, i]].name == "Knight"
					#print @pieces[[j, i]].team
					print "  "
				else
					print "    "
				end
				print "|"
			end
			print "\n"
			puts "-------------------------------------------"
		end
		puts "  |  0 |  1 |  2 |  3 |  4 |  5 |  6 |  7 |"
	end

	def print_symbol(name, team)
		if team == 1
			if name == "King"
				print "\u2654"
			elsif name == "Queen"
				print "\u2655"
			elsif name == "Castle"
				print "\u2656"
			elsif name == "Bishop"
				print "\u2657"
			elsif name == "Knight"
				print "\u2658"
			elsif name =="Pawn"
				print "\u2659"
			end
		else
			if name == "King"
				print "\u265A"
			elsif name == "Queen"
				print "\u265B"
			elsif name == "Castle"
				print "\u265C"
			elsif name == "Bishop"
				print "\u265D"
			elsif name == "Knight"
				print "\u265E"
			elsif name =="Pawn"
				print "\u265F"
			end
		end
	end

end
class Piece
	
	#team 1 means you start on the bottom, team 2 up top
	attr_accessor :name, :team, :board, :xCord, :yCord
	
	def initialize(name, team, board, xCord, yCord)
		@name = name
		@team = team
		@board = board
		@xCord = xCord
		@yCord = yCord
	end

	def get_castles(pieces, team)
		pieces_not_nil = @pieces.values.select{ |val| val!=nil }
		castles = pieces_not_nil.select { |val| val.name == "Castle" && val.team == team }
	end

	def check_on_board?(xCord, yCord)
		if xCord >= 8 || xCord < 0 || yCord >= 8 || yCord < 0
			return false
		end
		true
	end

	def is_on_same_team?(other)
		team == other.team
	end

	def is_on_other_team?(other)
		team != other.team
	end

	def take_moves_has?(pieces, coordinate)
		take_moves(pieces).include?(coordinate)
	end

	def square_is_open?(pieces, coordinate)
		check_on_board?(coordinate[0], coordinate[1]) && !pieces.fetch(coordinate)
	end

	def square_is_taken?(pieces, coordinate)
		check_on_board?(coordinate[0], coordinate[1]) && pieces.fetch(coordinate)
	end

	def square_taken_teammate?(pieces, coordinate)
		square_is_taken?(pieces, coordinate) && pieces.fetch(coordinate).team == team
	end

	def square_taken_opponent?(pieces, coordinate)
		square_is_taken?(pieces, coordinate) && pieces.fetch(coordinate).team != team
	end

	def is_protected?(pieces)
		pieces.each do |piece|
			return true if piece.protecting_moves(pieces).include?([@xCord, @yCord])
		end
		false
	end

end
class Knight < Piece

	def initialize(team, board, xCord, yCord)
		@name = "Knight"
		@team = team
		@board = board
		@xCord = xCord
		@yCord = yCord
	end


	#returns array of moves possible at given [x,y] that wouldn't involve taking another piece
	#ex of returned array= [ [1, 2], [2, 3], [4, 5])
	def get_moves(pieces)
		arrPos = []
		for coordinate_pair in [[@xCord + 2, @yCord + 1], [@xCord + 2, @yCord - 1], [@xCord - 2, @yCord + 1], [@xCord - 2, @yCord - 1], [@xCord - 1, @yCord + 2], [@xCord - 1, @yCord - 2], [@xCord + 1, @yCord - 2], [@xCord + 1, @yCord + 2]]
		arrPos << coordinate_pair if square_is_open?(pieces, coordinate_pair)
		end
		return arrPos
	end	

	#returns array of moves possible that would take another piece
	def take_moves(pieces)
		arrPos = []
		# add to array of take_moves if the move is on the board, there is another piece on the board and that piece is on the other team
		for coordinate_pair in [[@xCord + 2, @yCord + 1], [@xCord + 2, @yCord - 1], [@xCord - 2, @yCord + 1], [@xCord - 2, @yCord - 1], [@xCord - 1, @yCord + 2], [@xCord - 1, @yCord - 2], [@xCord + 1, @yCord - 2], [@xCord + 1, @yCord + 2]]
		arrPos << coordinate_pair if square_taken_opponent?(pieces, coordinate_pair)
		end
		return arrPos
	end

	#returns array of coordinates that are protected by this piece
	def protecting_moves(pieces)
		arrPieces = []
		# add to array of take_moves if the move is on the board, there is another piece on the board and that piece is on the same team
		for coordinate_pair in [[@xCord + 2, @yCord + 1], [@xCord + 2, @yCord - 1], [@xCord - 2, @yCord + 1], [@xCord - 2, @yCord - 1], [@xCord - 1, @yCord + 2], [@xCord - 1, @yCord - 2], [@xCord + 1, @yCord - 2], [@xCord + 1, @yCord + 2]]
		arrPieces << coordinate_pair if square_taken_teammate?(pieces, coordinate_pair)
		end
		return arrPieces
	end

end
class Castle < Piece

	attr_accessor :has_moved


	def initialize(team, board, xCord, yCord)
		@name = "Castle"
		@team = team
		@board = board
		@xCord = xCord
		@yCord = yCord
		@has_moved = false
	end
	
	#returns array of moves possible that wouldn't involve taking another piece
	def get_moves(pieces)
		check_up("open", pieces) + check_down("open", pieces) + check_right("open", pieces) + check_left("open", pieces)	
	end

	#returns array of possible moves that would involve taking another piece
	def take_moves(pieces)
		check_up("taken_opponent", pieces) + check_down("taken_opponent", pieces) + check_right("taken_opponent", pieces) + check_left("taken_opponent", pieces)					
	end

	#returns array of coordinates that are protected by this piece
	def protecting_moves(pieces)
		check_up("taken_teammate", pieces) + check_down("taken_teammate", pieces) + check_right("taken_teammate", pieces) + check_left("taken_teammate", pieces)
	end

	def check_right(type, pieces)
		arrPos = []
		((@xCord + 1)..7).each() do |i|
			if type == "open"
				if square_is_open?(pieces, [i, @yCord])
					arrPos << [i, @yCord]
				else
					break
				end
			elsif type == "taken_teammate"
				if square_taken_teammate?(pieces, [i, @yCord])
					arrPos << [i, @yCord]
					break
				end
			elsif type == "taken_opponent"
				if square_taken_opponent?(pieces, [i, @yCord])
					arrPos << [i, @yCord]
				break
				end
			end
		end
		arrPos
	end

	def check_left(type, pieces)
		arrPos = []
		(@xCord - 1).downto(0) do |i|
			if type == "open"
				if square_is_open?(pieces, [i, @yCord])
					arrPos << [i, @yCord]
				else
					break
				end
			elsif type == "taken_teammate"
				if square_taken_teammate?(pieces, [i, @yCord])
					arrPos << [i, @yCord]
					break
				end
			elsif type == "taken_opponent"
				if square_taken_opponent?(pieces, [i, @yCord])
					arrPos << [i, @yCord]
				break
				end
			end
		end
		arrPos
	end

	def check_up(type, pieces)
		arrPos = []
		((@yCord + 1)..7).each() do |i|
			if type == "open"
				if square_is_open?(pieces, [@xCord, i])
					arrPos << [@xCord, i]
				else
					break
				end
			elsif type == "taken_teammate"
				if square_taken_teammate?(pieces, [@xCord, i])
					arrPos << [@xCord, i]
					break
				end
			elsif type == "taken_opponent"
				if square_taken_opponent?(pieces, [@xCord, i])
					arrPos << [@xCord, i]
					break
				end
			end
		end
		arrPos
	end

	def check_down(type, pieces)
		arrPos = []
		(@yCord - 1).downto(0) do |i|
			if type == "open"
				if square_is_open?(pieces, [@xCord, i])
					arrPos << [@xCord, i]
				else
					break
				end
			elsif type == "taken_teammate"
				if square_taken_teammate?(pieces, [@xCord, i])
					arrPos << [@xCord, i]
					break
				end
			elsif type == "taken_opponent"
				if square_taken_opponent?(pieces, [@xCord, i])
					arrPos << [@xCord, i]
					break
				end
			end
		end
		arrPos
	end

end
class Pawn < Piece
	
	def initialize(team, board, xCord, yCord)
		@name = "Pawn"
		@team = team
		@board = board
		@xCord = xCord
		@yCord = yCord
	end

	#returns array of moves possible that wouldn't involve taking another piece
	def get_moves(pieces)
		arrPos = [] 
		if team == 1
			arrPos << [@xCord, @yCord + 1] if square_is_open?(pieces, [@xCord, @yCord + 1])
			arrPos << [@xCord, @yCord + 2] if @yCord == 1 && square_is_open?(pieces, [@xCord, @yCord + 2])
		elsif team == 2
			arrPos << [@xCord, @yCord - 1] if square_is_open?(pieces, [@xCord, @yCord - 1])
			arrPos << [@xCord, @yCord - 2] if @yCord == 6 && square_is_open?(pieces, [@xCord, @yCord - 2])
		end
		arrPos
	end

	#returns array of possible moves that would involve taking another piece
	#NEED TO IMPLEMENT AUMPUSAND
	def take_moves(pieces)
		arrPos = []
		if team == 1
			arrPos << [@xCord - 1, @yCord + 1] if square_taken_opponent?(pieces, [@xCord - 1, @yCord + 1])
			arrPos << [@xCord + 1, @yCord + 1] if square_taken_opponent?(pieces, [@xCord + 1, @yCord + 1])
		elsif team == 2
			arrPos << [@xCord - 1, @yCord - 1] if square_taken_opponent?(pieces, [@xCord - 1, @yCord - 1])
			arrPos << [@xCord + 1, @yCord - 1] if square_taken_opponent?(pieces, [@xCord + 1, @yCord - 1])
		end
		arrPos	
	end

	#returns array of coordinates that are protected by this piece
	def protecting_moves(pieces)
		arrPos = []
		if team == 1
			arrPos << [@xCord - 1, @yCord + 1] if square_taken_teammate?(pieces, [@xCord - 1, @yCord + 1])
			arrPos << [@xCord + 1, @yCord + 1] if square_taken_teammate?(pieces, [@xCord + 1, @yCord + 1])
		elsif team == 2
			arrPos << [@xCord - 1, @yCord - 1] if square_taken_teammate?(pieces, [@xCord - 1, @yCord - 1])
			arrPos << [@xCord + 1, @yCord - 1] if square_taken_teammate?(pieces, [@xCord + 1, @yCord - 1])
		end
		arrPos	
	end
	
end
class Bishop < Piece

	def initialize(team, board, xCord, yCord)
		@name = "Bishop"
		@team = team
		@board = board
		@xCord = xCord
		@yCord = yCord
	end

	#returns array of moves possible that wouldn't involve taking another piece
	def get_moves(pieces)
		arrPos = []
		upRight, upLeft, downRight, downLeft = true, true, true, true
		for i in 1..7
			upRight = false if square_is_taken?(pieces, [@xCord + i, @yCord + i])
			upLeft = false if square_is_taken?(pieces, [@xCord - i, @yCord + i])
			downRight = false if square_is_taken?(pieces, [@xCord + i, @yCord - i])
			downLeft = false if square_is_taken?(pieces, [@xCord - i, @yCord - i])
			arrPos << [@xCord + i, @yCord + i] if upRight
			arrPos << [@xCord - i, @yCord + i] if upLeft
			arrPos << [@xCord + i, @yCord - i] if downRight
			arrPos << [@xCord - i, @yCord - i] if downLeft
		end
		arrPos
	end

	#returns array of possible moves that would involve taking another piece
	def take_moves(pieces)
		arrPos = []
		upRight, upLeft, downRight, downLeft = true, true, true, true
		for i in 1..7
			if upRight && square_taken_opponent?(pieces, [@xCord + i, @yCord + i])
				upRight = false
				arrPos << [@xCord + i, @yCord + i] 
			end
			if upLeft && square_taken_opponent?(pieces, [@xCord - i, @yCord + i])
				upLeft = false
				arrPos << [@xCord - i, @yCord + i] 
			end
			if downRight && square_taken_opponent?(pieces, [@xCord + i, @yCord - i])
				downRight = false
				arrPos << [@xCord + i, @yCord - i] 
			end
			if downLeft && square_taken_opponent?(pieces, [@xCord - i, @yCord - i])
				downLeft = false
				arrPos << [@xCord - i, @yCord - i] 
			end
		end
		arrPos
	end

	#returns array of coordinates that are protected by this piece
	def protecting_moves(pieces)
		arrPos = []
		upRight, upLeft, downRight, downLeft = true, true, true, true
		for i in 1..7
			if upRight && square_taken_teammate?(pieces, [@xCord + i, @yCord + i])
				upRight = false
				arrPos << [@xCord + i, @yCord + i] 
			end
			if upLeft && square_taken_teammate?(pieces, [@xCord - i, @yCord + i])
				upLeft = false
				arrPos << [@xCord - i, @yCord + i] 
			end
			if downRight && square_taken_teammate?(pieces, [@xCord + i, @yCord - i])
				downRight = false
				arrPos << [@xCord + i, @yCord - i] 
			end
			if downLeft && square_taken_teammate?(pieces, [@xCord - i, @yCord - i])
				downLeft = false
				arrPos << [@xCord - i, @yCord - i] 
			end
		end
		arrPos
	end

end
class Queen < Piece

	def initialize(team, board, xCord, yCord)
		@name = "Queen"
		@team = team
		@board = board
		@xCord = xCord
		@yCord = yCord
	end

	#returns array of moves possible that wouldn't involve taking another piece
	def get_moves(pieces)
		fakeBishop = Bishop.new(@team, @board, @xCord, @yCord)
		fakeCastle = Castle.new(@team, @board, @xCord, @yCord)
		arrPos = fakeBishop.get_moves(pieces) + fakeCastle.get_moves(pieces)
		fakeBishop = nil
		fakeCastle = nil
		arrPos
	end

	#returns array of possible moves that would involve taking another piece
	def take_moves(pieces)
		fakeBishop = Bishop.new(@team, @board, @xCord, @yCord)
		fakeCastle = Castle.new(@team, @board, @xCord, @yCord)
		arrPos = fakeBishop.take_moves(pieces) + fakeCastle.take_moves(pieces)
		fakeBishop = nil
		fakeCastle = nil
		arrPos
	end

	#returns array of coordinates that are protected by this piece
	def protecting_moves(pieces)
		fakeBishop = Bishop.new(@team, @board, @xCord, @yCord)
		fakeCastle = Castle.new(@team, @board, @xCord, @yCord)
		arrPos = fakeBishop.protecting_moves(pieces) + fakeCastle.protecting_moves(pieces)
		fakeBishop = nil
		fakeCastle = nil
		arrPos
	end

end
class King < Piece

	attr_accessor :has_moved

	def initialize(team, board, xCord, yCord)
		@name = "King"
		@team = team
		@board = board
		@xCord = xCord
		@yCord = yCord
		@has_moved = false
	end

	#returns array of moves possible that wouldn't involve taking another piece
	def get_moves(pieces)
		arrPos = []
		for coordinate_pair in [ [@xCord+1, @yCord+1], [@xCord-1, @yCord-1], [@xCord-1, @yCord+1], [@xCord+1, @yCord-1], [@xCord, @yCord+1], [@xCord, @yCord-1], [@xCord+1, @yCord], [@xCord-1, @yCord] ]
			arrPos << coordinate_pair if square_is_open?(pieces, coordinate_pair)
		end
		arrPos
	end

	#returns array of possible moves that would involve taking another piece
	def take_moves(pieces)
		arrPos = []
		for coordinate_pair in [ [@xCord+1, @yCord+1], [@xCord-1, @yCord-1], [@xCord-1, @yCord+1], [@xCord+1, @yCord-1], [@xCord, @yCord+1], [@xCord, @yCord-1], [@xCord+1, @yCord], [@xCord-1, @yCord] ]
			arrPos << coordinate_pair if square_taken_opponent?(pieces, coordinate_pair)
		end
		arrPos
	end

	#returns array of coordinates that are protected by this piece
	def protecting_moves(pieces)
		arrPos = []
		for coordinate_pair in [ [@xCord+1, @yCord+1], [@xCord-1, @yCord-1], [@xCord-1, @yCord+1], [@xCord+1, @yCord-1], [@xCord, @yCord+1], [@xCord, @yCord-1], [@xCord+1, @yCord], [@xCord-1, @yCord] ]	
			arrPos << coordinate_pair if square_taken_opponent?(pieces, coordinate_pair)
		end
		arrPos
	end

	def is_in_check?(pieces)
		pieces_not_nil = pieces.values.select{ |value| value != nil }
		other_team = pieces_not_nil.select { |value| value.team != @team }
		attacked = false
		other_team.each do |piece|
			poss_takes = piece.take_moves(pieces)
			attacked = true if poss_takes.include?([@xCord, @yCord])
		end
		attacked
	end

	#returns true if king has no possible moves
	def can_move?(pieces)
		has_moves = false 
		total_poss_moves = get_moves(pieces) + take_moves(pieces)
		#loop through all possible moves of king
		for i in total_poss_moves
			has_moves = true if can_move_to?(pieces, i)
		end
		has_moves
	end

	#check each piece on the other team to see if they can take that square
	#in the case that there is another piece there, it needs to be protected so we need to see if 
	#a different piece can take that square
	#otherwise, we just need to see if the king is allowed to move there w/o being threatened
	def can_move_to?(pieces, coordinate)
		#if it's not one of the moves that the king can move/take to return false
		return false unless (get_moves(pieces) + take_moves(pieces)).include?(coordinate)
		pieces_not_nil = pieces.values.select{ |value| value != nil }
		other_team = pieces_not_nil.select { |value| value.team != @team }
		#if the square is empty
		if square_is_open?(pieces,coordinate)
			other_team.each do |piece|
				possible_takes = piece.take_moves(pieces)
				#if a piece on there team can take this position, the king can't move to this location
				return false if possible_takes.include?(coordinate)
			end
		#if the square contains a piece on the opponents team
		else
			piece_at_square = pieces[coordinate]
			#if the piece at that square is protected return false
			return false if piece_at_square.is_protected?(pieces)
		end
		true
	end

	def is_in_checkmate?(pieces)
		return true if is_in_check?(pieces) && !can_move?(pieces)
	end

end

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
		#print "Enter EXIT to exit:"
		#x = gets.chomp
		#exit if x == "EXIT"
		in_check = false
		puts "It's " + name + "'s turn!\nYou are player #" + turn.to_s
		piece_to_move, x, y = nil, nil, nil
		valid_input = false
		until valid_input
			puts "What piece would you like to move? Say LIST to list acceptable inputs"
			piece_to_move = gets.chomp
			if piece_to_move == "LIST"
				puts "NOTE: CASE SENSITIVE\nThe options are: Knight, Horse, Castle, Bishop, King, Queen, Pawn"
			else
			valid_input = true if piece_to_move == "Knight" || piece_to_move == "Horse" || piece_to_move == "Castle" || piece_to_move == "Bishop" || piece_to_move == "King" || piece_to_move == "Queen" ||  piece_to_move == "Pawn"
			end
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
