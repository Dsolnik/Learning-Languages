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