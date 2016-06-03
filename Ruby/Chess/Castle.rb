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