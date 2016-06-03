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
					print @pieces[[j, i]].name[0] unless @pieces[[j, i]].name == "Knight"
					print "H" if @pieces[[j, i]].name == "Knight"
					print @pieces[[j, i]].team
					print " "
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

end