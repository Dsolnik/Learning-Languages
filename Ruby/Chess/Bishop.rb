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