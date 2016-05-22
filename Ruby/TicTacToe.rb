class TicTacToe
	def initialize(play1name,play1symbol,play2name,play2symbol)
		@board=Array.new(3){Array.new(3)}
		@name1=play1name
		@sym1=play1symbol
		@name2=play2name
		@sym2=play2symbol
	end

	def displayBoard
		for i in 0..2
			first=getPlayer(i,0) ? getSym(getPlayer(i,0)) :  " "
			second=getPlayer(i,1) ? getSym(getPlayer(i,1)) :  " "
			third=getPlayer(i,2) ? getSym(getPlayer(i,2)) :  " "
			puts "  " + first + "  |  " + second + "  |  " + third 
			puts "-----------------" unless i==2
		end
	end

	def getPlayer(row,col)
		if @board[row.to_i][col.to_i]==@sym1
			return @name1
		elsif @board[row.to_i][col.to_i]==@sym2
			return @name2
		end
	end

	def getSym(name)
		if name==@name1
			return @sym1
		else
			return @sym2
		end
	end

	# if no winner:
	# 	returns nil
	# if winner:
	# 	returns name of winner
	def getWinner
		for i in 0..2 
			if @board[i][0]!=nil && @board[i][0]==@board[i][1] && @board[i][1]==@board[i][2] #checks rows
				return getPlayer(i,0)
			elsif @board[0][i]!=nil && @board[0][i]==@board[1][i] && @board[1][i]==@board[2][i] #checks columbs
				return getPlayer(0,i)
			end
		end
		if @board[1][1]!=nil && @board[0][0]==@board[1][1] && @board[1][1]==@board[2][2] #checks / diagonal
			return getPlayer(1,1)
		elsif @board[1][1]!=nil && @board[0][2]==@board[1][1] && @board[1][1]==@board[2][0] #checks \ diagonal
			return getPlayer(1,1)
		end
		nil
	end


	# if valid move:
	# 	displays board and returns true
	# if not:
	# 	displays board and returns false 
	def move(name,row,col)
		sym=getSym(name)
		unless getPlayer(row,col)
			@board[row.to_i][col.to_i]=sym
			displayBoard
			return true 
		end
		displayBoard
		return false
	end

	def gameOver
		if getWinner
			return true
		else 
			totalFilled=true
			for i in 0..2
				for j in 0..2
					totalFilled=false if @board[i][j]==nil
				end
			end
			return true if totalFilled
		end
		false
	end

end
puts "------------------------------------------------------------------------------------------------"
puts "Notice! Rows goes from 0-2 and Columns go from 0-2. In other words, the first row down is row 0,\nthe second row 1, etc."
puts "------------------------------------------------------------------------------------------------"
puts "Player 1: Enter your name"
name1=gets.chomp
puts "Player 1: Enter your symbol"
sym1=gets.chomp
puts "Player 2: Enter your name"
name2=gets.chomp
puts "Player 2: Enter your symbol"
sym2=gets.chomp
game = TicTacToe.new(name1,sym1,name2,sym2)
moveNum=0
game.displayBoard
while(!game.gameOver)
	playerNum=moveNum%2
	playerName= ""
	if playerNum==0
		playerName=name1
	else
		playerName=name2
	end
	puts playerName + ", choose a row!"
	row=gets.chomp
	puts playerName + ", choose a column!"
	col=gets.chomp
	if game.move(playerName,row,col)
		moveNum+=1
		if game.getWinner
			"Congratulations " + game.getWinner + "! You won in " + moveNum.to_s + " moves"
		end
	else
		puts "Invalid input! Choose again!"
	end
end