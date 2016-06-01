class Board

	def initialize
		@board=[]
		8.times{ @board.push(Array.new(8)) }
		@pieces=Hash.new()
	end

	#returns true if worked and there is no other piece in that coordinate or false if didn't
	def add_piece(piece, xCord, yCord)
		unless @pieces[[xCord,yCord]]
			@pieces[[xCord,yCord]] = piece
			return true
		end
		return false
	end

	#returns true if it worked, false if there is a piece where you want to move or
	#if piece isn't on board
	def move_piece(piece, xCord, yCord)
		if add_piece(piece,[xCord,yCord])
			@pieces.delete_if {|key, value| value == piece }
			return true
		else
			return false
	end

end

class Knight

	#returns array of moves possible at given [x,y]
	def get_moves_at(xCord, yCord)
		arrPos = []
		arrPos += [xCord+2, yCord+1] if check(xCord+2, yCord+1)
		arrPos += [xCord+2, yCord-1] if check(xCord+2, yCord-1)
		arrPos += [xCord-2, yCord+1] if check(xCord-2, yCord+1)
		arrPos += [xCord-2, yCord+1] if check(xCord-2, yCord-1)

		arrPos += [xCord-1, yCord+2] if check(xCord-1, yCord+2)
		arrPos += [xCord+1, yCord+2] if check(xCord+1, yCord+2)
		arrPos += [xCord-1, yCord-2] if check(xCord-1, yCord-2)
		arrPos += [xCord+1, yCord+2] if check(xCord+1, yCord+2)
	end	

	#returns true if it's a valid move, false if not
	def check(xCord, yCord)
		if xCord >= 8 || xCord < 0 || yCord >= 8 || yCord < 0
			return false
		end
		true
	end

	def knight_moves(start, fin)
		queue=[start]
		
	end
end