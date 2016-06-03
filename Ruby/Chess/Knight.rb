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