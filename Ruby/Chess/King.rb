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