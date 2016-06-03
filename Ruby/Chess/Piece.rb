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

#NOTE: CONTINUE CASTLING
	def get_king(pieces, team)
		pieces_not_nil = @pieces.values.select{ |val| val!=nil }
		king = pieces_not_nil.select { |val| val.name == "King" && val.team == team }
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
