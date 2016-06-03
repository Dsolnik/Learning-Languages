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