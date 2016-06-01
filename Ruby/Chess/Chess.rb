#note to self:
# => take_moves doesn't account for teams
#TO DO:
# => Castling
# => ampusand
# => stalemate
class Chess_Game
	
	attr_accessor :player1, :player2, :board
	
	def initialize (name1, name2)
		@player1 = name1
		@player2 = name2
	end

	def start_game
		puts @board ? "Game is already underway" : "Game started"
		@board = Board.new unless @board
	end

	def end_game
		if @board
			@board = nil
			puts "Game ended"
		else
			puts "No game is underway"
		end
	end

	def checkmate?
		king1 = @board.get_piece("King", 1)
		king2 = @board.get_piece("King", 2)
		for king in [king1, king2]
			if king.is_in_check? && !king.has_moves?
				puts "Game's Over!"
				puts king.team == 1 ? player2 + ", you win!" : player1 + ", you win!"
				gets.chomp
				exit
				break
			end
		end
	end

	def move_piece(name, team, coordinate)
		piece = @board.get_piece(name, team)
		@board.move_piece(piece, coordinate) if check_valid_move(piece, coordinate)
	end

	def check_valid_move(piece, coordinate)
		xCord, yCord = coordinate
		return false if xCord >= 8 || xCord < 0 || yCord >= 8 || yCord < 0
		return false unless @board.is_open?(coordinate)
		arrMoves = piece.get_moves(@board.pieces)
		return true if arrMoves.include?(coordinate)
		if piece.class == King
			return true if piece.can_move_to?(pieces, coordinate)
		else
			return true if piece.is_valid_take?(pieces,coordinate)
		end
	end

end

class Board
	attr_accessor :pieces, :board

	def initialize
		@board = []
		8.times{ @board.push(Array.new(8)) }
		@pieces = Hash.new()
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
		add_piece(Pawn.new(1, self, 3, 0))
		add_piece(Pawn.new(2, self, 3, 7))
		#Kings
		add_piece(King.new(1, self, 4, 0))
		add_piece(King.new(2, self, 4, 7))
	end

	def is_open?(coordinate)
		return true unless @pieces[coordinate]
		false
	end

	def add_piece(piece, coordinate)
		@pieces[coordinate] = piece
	end

	#returns true if it worked, false if there is a piece where you want to move or
	#if piece isn't on board
	#input:
	# => piece: object
	# => coordinate: [xCord, yCord]
	def move_piece(piece, coordinate)
		if pieces[coordinate]
			@pieces.delete(coordinate)
		end
			oldx = piece.xCord
			oldy = piece.yCord
			piece.xCord, piece.yCord = coordinate
			@pieces[coordinate] = piece.clone()
			@pieces.delete([oldx,oldy])
	end

	def get_piece(name, team)
		for i in @pieces
			return i if i.name==name && i.team==team
		end
	end

	def output_board
		puts "----------------"
		7.downto(0) do |i|
			print "#{i} |"
			for j in 0..7
				if @pieces[i, j]
					print " "
					print @pieces[i, j].name[0]
					print @pieces[i, j].team
					print " "
				else
					print "   "
				end
				print "|"
			end
			print "|\n"
			puts "----------------"
		end
		puts "   0  1  2  3  4  5  6  7"
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
	#returns array of possible moves that wouldn't involve taking
	def get_moves

	end
	#returns array of possible moves that involve taking
	def take_moves
		get_moves
	end

	def check_on_board?(xCord, yCord)
		if xCord >= 8 || xCord < 0 || yCord >= 8 || yCord < 0
			return false
		end
		true
	end

	def is_on_same_team(other)
		team == other.team
	end

	def is_valid_take?(pieces, coordinate)
		take_moves.include?(coordinate) && !is_on_same_team(pieces[coordinate])
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

	#returns array of moves possible at given [x,y]
	#ex of returned array= [ [1, 2], [2, 3], [4, 5] ]
	def get_moves(pieces)
		arrPos = []
		arrPos << [xCord+2, yCord+1] if check_on_board?(xCord+2, yCord+1) && !pieces[ [xCord+2, yCord+1] ]
		arrPos << [xCord+2, yCord-1] if check_on_board?(xCord+2, yCord-1) && !pieces[ [xCord+2, yCord-1] ]
		arrPos << [xCord-2, yCord+1] if check_on_board?(xCord-2, yCord+1) && !pieces[ [xCord-2, yCord+1] ]
		arrPos << [xCord-2, yCord-1] if check_on_board?(xCord-2, yCord-1) && !pieces[ [xCord-2, yCord-1] ]

		arrPos << [xCord-1, yCord+2] if check_on_board?(xCord-1, yCord+2) && !pieces[ [xCord-1, yCord+2] ]
		arrPos << [xCord-1, yCord-2] if check_on_board?(xCord-1, yCord-2) && !pieces[ [xCord-1, yCord-2] ]
		arrPos << [xCord+1, yCord-2] if check_on_board?(xCord+1, yCord-2) && !pieces[ [xCord+1, yCord-2] ]
		arrPos << [xCord+1, yCord+2] if check_on_board?(xCord+1, yCord+2) && !pieces[ [xCord+1, yCord+2] ]
		arrPos
	end	

	def take_moves(pieces)
		arrPos = []
		arrPos << [xCord+2, yCord+1] if check_on_board?(xCord+2, yCord+1) && pieces[ [xCord+2, yCord+1] ]
		arrPos << [xCord+2, yCord-1] if check_on_board?(xCord+2, yCord-1) && pieces[ [xCord+2, yCord-1] ]
		arrPos << [xCord-2, yCord+1] if check_on_board?(xCord-2, yCord+1) && pieces[ [xCord-2, yCord+1] ]
		arrPos << [xCord-2, yCord-1] if check_on_board?(xCord-2, yCord-1) && pieces[ [xCord-2, yCord-1] ]
		
		arrPos << [xCord-1, yCord+2] if check_on_board?(xCord-1, yCord+2) && pieces[ [xCord-1, yCord+2] ]
		arrPos << [xCord-1, yCord-2] if check_on_board?(xCord-1, yCord-2) && pieces[ [xCord-1, yCord-2] ]
		arrPos << [xCord+1, yCord-2] if check_on_board?(xCord+1, yCord-2) && pieces[ [xCord+1, yCord-2] ]
		arrPos << [xCord+1, yCord+2] if check_on_board?(xCord+1, yCord+2) && pieces[ [xCord+1, yCord+2] ]
		arrPos
	end

end

class Castle < Piece

	def initialize(team, board, xCord, yCord)
		@name = "Castle"
		@team = team
		@board = board
		@xCord = xCord
		@yCord = yCord
	end
	
	def get_moves(pieces)
		arrPos = []
		donePart = false
		xCord.downto(0) do |i|
			unless pieces[ [i, yCord] ]
				arrPos << [i, yCord]
			else
				break
			end
		end
		for i in xCord+1..7
			unless pieces[ [i, yCord] ]
				arrPos << [i, yCord]
			else
				break
			end			
		end
		yCord.downto(0) do |i|
			unless pieces[ [xCord, i] ]
				arrPos << [xCord,i]
			else
				break
			end
		end
		for i in xCord+1..7
			unless pieces[ [xCord, i] ]
				arrPos << [xCord,i]
			else
				break
			end
		end
		arrPos		
	end

	def take_moves
		arrPos = []
		xCord.downto(0) do |i|
			if pieces[ [i, yCord] ]
				arrPos << [i, yCord]
				break
			end
		end

		for i in xCord+1..7
			if pieces[ [i, yCord] ]
				arrPos << [i, yCord]
				break
			end
		end

		yCord.downto(0) do |i|
			if pieces[ [xCord, i] ]
				arrPos << [xCord,i]
				break
			end
		end

		for i in xCord+1..7
			if pieces[ [xCord, i] ]
				arrPos << [xCord,i]
				break
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
	
	def get_moves(pieces)
		arrPos = [] 
		if team == 1
			arrPos << [xCord, yCord+1] if check_on_board?(xCord, yCord+1) && !pieces[ [xCord, yCord+1] ]
			arrPos << [xCord, yCord+2] if yCord == 1 && check_on_board?(xCord, yCord+2) && !pieces[ [xCord, yCord+2] ]
		elsif team ==2
			arrPos << [xCord, yCord-1] if check_on_board?(xCord, yCord-1) && !pieces[ [xCord, yCord-1] ]
			arrPos << [xCord, yCord-2] if yCord == 6 && check_on_board?(xCord, yCord-2) && !pieces[ [xCord, yCord-2] ]
		end
		arrPos
	end

	def take_moves(pieces)
		arrPos = []
		if team == 1
			arrPos << [xCord-1,yCord+1] if check_on_board?(xCord-1, yCord+1) && pieces[ [xCord-1, yCord+1] ]
			arrPos << [xCord+1,yCord+1] if check_on_board?(xCord+1, yCord+1) && pieces[ [xCord+1, yCord+1] ]
		elsif team == 2
			arrPos << [xCord-1,yCord-1] if check_on_board?(xCord-1, yCord-1) && pieces[ [xCord-1, yCord-1] ]
			arrPos << [xCord+1,yCord-1] if check_on_board?(xCord+1, yCord-1) && pieces[ [xCord+1, yCord-1] ]		
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

	def get_moves(pieces)
		arrPos = []
		upRight, upLeft, downRight, downLeft = true, true, true, true
		for i in 1..7
			upRight = false if pieces[ [xCord+i, yCord+i] ]
			upLeft = false if pieces[ [xCord-i, yCord+i] ]
			downRight = false if pieces[ [xCord+i, yCord-i] ]
			downLeft = false if pieces[ [xCord-i, yCord-i] ]
			arrPos << [xCord+i, yCord+i] if upRight
			arrPos << [xCord-i, yCord+i] if upLeft
			arrPos << [xCord+i, yCord-i] if downRight
			arrPos << [xCord-i, yCord-i] if downLeft
		end
		arrPos
	end

	def take_moves(pieces)
		arrPos = []
		upRight, upLeft, downRight, downLeft = true, true, true, true
		for i in 1..7
			if upRight && pieces[ [xCord+i, yCord+i] ]
				upRight = false
				arrPos << [xCord+i, yCord+i] 
			end
			if upLeft && pieces[ [xCord-i, yCord+i] ]
				upLeft = false
				arrPos << [xCord-i, yCord+i] 
			end
			if downRight && pieces[ [xCord+i, yCord-i] ]
				upLeft = false
				arrPos << [xCord+i, yCord-i] 
			end
			if downLeft && pieces[ [xCord-i, yCord-i] ]
				downLeft = false
				arrPos << [xCord-i, yCord-i] 
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

	def get_moves(pieces)
		arrPos = []
		donePart = false
		#castle code
		xCord.downto(0) do |i|
			unless pieces[ [i, yCord] ]
				arrPos << [i, yCord]
			else
				break
			end
		end
		for i in xCord+1..7
			unless pieces[ [i, yCord] ]
				arrPos << [i, yCord]
			else
				break
			end			
		end
		yCord.downto(0) do |i|
			unless pieces[ [xCord, i] ]
				arrPos << [xCord,i]
			else
				break
			end
		end
		for i in xCord+1..7
			unless pieces[ [xCord, i] ]
				arrPos << [xCord,i]
			else
				break
			end
		end		
		#bishop code
		upRight, upLeft, downRight, downLeft = true, true, true, true
		for i in 1..7
			upRight = false if pieces[ [xCord+i, yCord+i] ]
			upLeft = false if pieces[ [xCord-i, yCord+i] ]
			downRight = false if pieces[ [xCord+i, yCord-i] ]
			downLeft = false if pieces[ [xCord-i, yCord-i] ]
			arrPos << [xCord+i, yCord+i] if upRight
			arrPos << [xCord-i, yCord+i] if upLeft
			arrPos << [xCord+i, yCord-i] if downRight
			arrPos << [xCord-i, yCord-i] if downLeft
		end
		arrPoss
	end

	def take_moves(pieces)
		arrPos = []
		xCord.downto(0) do |i|
			if pieces[ [i, yCord] ]
				arrPos << [i, yCord]
				break
			end
		end
		for i in xCord+1..7
			if pieces[ [i, yCord] ]
				arrPos << [i, yCord]
				break
			end
		end
		yCord.downto(0) do |i|
			if pieces[ [xCord, i] ]
				arrPos << [xCord,i]
				break
			end
		end
		for i in xCord+1..7
			if pieces[ [xCord, i] ]
				arrPos << [xCord,i]
				break
			end
		end
		upRight, upLeft, downRight, downLeft = true, true, true, true
		for i in 1..7
			if upRight && pieces[ [xCord+i, yCord+i] ]
				upRight = false
				arrPos << [xCord+i, yCord+i]
			end
			if upLeft && pieces[ [xCord-i, yCord+i] ]
				upLeft = false
				arrPos << [xCord-i, yCord+i]
			end
			if downRight && pieces[ [xCord+i, yCord-i] ]
				upLeft = false
				arrPos << [xCord+i, yCord-i]
			end
			if downLeft && pieces[ [xCord-i, yCord-i] ]
				downLeft = false
				arrPos << [xCord-i, yCord-i]
			end
		end
		arrPos		
	end

end

class King < Piece

	def initialize(team, board, xCord, yCord)
		@name = "King"
		@team = team
		@board = board
		@xCord = xCord
		@yCord = yCord
	end

	def get_moves(pieces)
		arrPos = []
		#diagonals
		arrPos << [xCord+1, yCord+1] if check_on_board?(xCord+1, yCord+1) && !pieces[ [xCord+1, yCord+1] ]
		arrPos << [xCord-1, yCord-1] if check_on_board?(xCord-1, yCord-1) && !pieces[ [xCord-1, yCord-1] ]
		arrPos << [xCord-1, yCord+1] if check_on_board?(xCord-1, yCord+1) && !pieces[ [xCord-1, yCord+1] ]
		arrPos << [xCord+1, yCord-1] if check_on_board?(xCord+1, yCord-1) && !pieces[ [xCord+1, yCord-1] ]

		arrPos << [xCord, yCord+1] if check_on_board?(xCord, yCord+1) && !pieces[ [xCord, yCord+1] ]
		arrPos << [xCord, yCord-1] if check_on_board?(xCord, yCord-1) && !pieces[ [xCord, yCord-1] ]
		arrPos << [xCord+1, yCord] if check_on_board?(xCord+1, yCord) && !pieces[ [xCord+1, yCord] ]
		arrPos << [xCord-1, yCord] if check_on_board?(xCord-1, yCord) && !pieces[ [xCord-1, yCord] ]
		arrPos
	end

	def take_moves(pieces)
		arrPos = []
		#diagonals
		arrPos << [xCord+1, yCord+1] if check_on_board?(xCord+1, yCord+1) && pieces[ [xCord+1, yCord+1] ]
		arrPos << [xCord-1, yCord-1] if check_on_board?(xCord-1, yCord-1) && pieces[ [xCord-1, yCord-1] ]
		arrPos << [xCord-1, yCord+1] if check_on_board?(xCord-1, yCord+1) && pieces[ [xCord-1, yCord+1] ]
		arrPos << [xCord+1, yCord-1] if check_on_board?(xCord+1, yCord-1) && pieces[ [xCord+1, yCord-1] ]

		arrPos << [xCord, yCord+1] if check_on_board?(xCord, yCord+1) && pieces[ [xCord, yCord+1] ]
		arrPos << [xCord, yCord-1] if check_on_board?(xCord, yCord-1) && pieces[ [xCord, yCord-1] ]
		arrPos << [xCord+1, yCord] if check_on_board?(xCord+1, yCord) && pieces[ [xCord+1, yCord] ]
		arrPos << [xCord-1, yCord] if check_on_board?(xCord-1, yCord) && pieces[ [xCord-1, yCord] ]
		arrPos
	end

	def is_in_check?(pieces)
		other_team = @pieces.collect { |key, value| value.team == king.team}
		king_can_move_here = true
		other_team.each_value do |piece|
			poss_takes = piece.take_moves
			king_can_move_here = false if poss_takes.include?([xCord,yCord])
		end
	end

	def can_move?(pieces)
		has_moves = false
		total_spaces = get_moves(pieces) + take_moves(pieces)
		other_team = pieces.collect{ |key, value| value.team == king.team}.values
		#loop through all possible moves of king
		for i in total_spaces
			has_moves = true if can_move_to(pieces, i)
		end
		has_moves
	end
	#check each piece on the other team to see if they can take that square
	#in the case that there is another piece there, it needs to be protected so we need to see if 
	#a different piece can take that square
	#otherwise, we just need to see if the king is allowed to move there w/o being threatened
	def can_move_to?(pieces, coordinate)
		other_team = pieces.collect{ |key, value| value.team == king.team}.values
		other_team.each do |piece|
			possible_takes = piece.take_moves(pieces)
			#if a piece on there team can take this position, the king can't move to this location
			return false if possible_takes.include?(coordinate)
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