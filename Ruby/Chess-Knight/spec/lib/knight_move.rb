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

end

class Knight

	#returns array of moves possible at given [x,y]
	#ex of returned array= [ [1, 2], [2, 3], [4, 5] ]
	def get_moves_at(xCord, yCord)
		arrPos = []

		arrPos << [xCord+2, yCord+1] if check?(xCord+2, yCord+1)
		arrPos << [xCord+2, yCord-1] if check?(xCord+2, yCord-1)
		arrPos << [xCord-2, yCord+1] if check?(xCord-2, yCord+1)
		arrPos << [xCord-2, yCord-1] if check?(xCord-2, yCord-1)

		arrPos << [xCord-1, yCord+2] if check?(xCord-1, yCord+2)
		arrPos << [xCord-1, yCord-2] if check?(xCord-1, yCord-2)
		arrPos << [xCord+1, yCord-2] if check?(xCord+1, yCord-2)
		arrPos << [xCord+1, yCord+2] if check?(xCord+1, yCord+2)
		return arrPos
	end	

	#returns true if it's a valid move, false if not
	def check?(xCord, yCord)
		if xCord >= 8 || xCord < 0 || yCord >= 8 || yCord < 0
			return false
		end
		true
	end


	#example of queue arr = [ [ [0,0],[1,1],[1,2] ],  ]
	# => = [ [ [xCord,yCord],[xCord,yCord] ] ]
	#input types:
	# => start = [xCord,yCord]
	# => fin = [xCord,yCord]
	#return type:
	# => array of xy coordinates arrays
	# => ex: [ [3, 3], [5, 4], [3, 5], [4, 3] ]
	def knight_moves(start, fin)
		#start with initial path = start
		queue = [[start]]
		rightPath = nil
		#loop until we find a path
		while !rightPath
			#get array of moves 
			arrMoves = get_moves_at(queue[0][-1][0],queue[0][-1][1])
			#if the moves has the destination, add the destination to the current path and set the right path = to this
			if arrMoves.include?(fin)
				queue[0] << fin 
				#copy queue[0] to rightPath
				rightPath = queue[0].collect{|val| val}
			end
			for i in arrMoves
				#push new path to queue, which is the current path + the next possible destination
				newPath = queue[0].collect{ |val| val } << i
				queue << newPath
			end
			#delete first object in queue because we're explored all its possible connections
			queue.delete_at(0)
		end

		puts "You made it in #{rightPath.length-1} moves! Here's your path:"
		for i in rightPath
			puts i.inspect
		end
		rightPath
	end

end
knight = Knight.new() 
knight.knight_moves([3,3],[4,3])