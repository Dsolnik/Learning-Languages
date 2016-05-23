class Integer
	def factorial
		self <= 1 ? 1 : self * (self - 1).factorial
	end
end 

class Mastermind

	attr_accessor @pattern
	
	def listPermutations(arr)
		possArray=Array.new()
		arr.each_with_index do |val,index|
			val.times do
				possArray << index
			end
		end
		puts possArray.to_s
		puts possArray.combination(possArray.length)
		possArray.permutation(possArray.length).each do |a|
			puts a.join(" ")
		end
	end

	# If given 4 inputs:
	# 	initializes pattern to the inputs
	# Else:
	# 	initializes patten randomly to numbers 1-4
	def initialize(a = nil, b = nil, c = nil, d = nil)
		@pattern= Array.new(4)
		if a!=nil && b!=nil && c!=nil && d!=nil
			@pattern[0], @pattern[1], @pattern[2], @pattern[3], @mode = a, b, c, d, 1
		else
			@pattern[0], @pattern[1], @pattern[2], @pattern[3], @mode = 1 + rand(4), 1 + rand(4), 1 + rand(4), 1 + rand(4), 0
		end
	end

	def checkPattern(a, b, c, d)
		rightPos,rightColor = 0, 0
		arrInput = [a, b, c, d]
		arrCheck = Array.new(@pattern)
		# checks for numbers in the right position and deletes them if right
		for i in 0..3
			if arrInput[i] == arrCheck[i]
				rightPos += 1
				arrInput[i],arrCheck[i] = nil,nil
				puts "found!\n#{arrInput.to_s}\n #{arrCheck.to_s}\n#{@pattern}"
			end
		end
		# checks for numbers with right value and deletes them if found
		for val in arrInput
			for j in 0..2
				if val != nil && val == arrCheck[j]
					rightColor += 1
					arrInput[j] = nil
					arrCheck[j] = nil
					puts "found!2\n#{arrInput.to_s}\n #{arrCheck.to_s}\n#{@pattern}"
					break
				end
			end
		end
		won = false
		if rightPos == 4
			puts "Congratulations! You won!"
			won = true
		end
		return [won,rightPos,rightColor]
	end

end

correctInput=false
mode=0
while(!correctInput)
	puts "Welcome to Mastermind!\nIf you'd like the computer to guess: enter 0\nIf you'd like the computer to generate a random pattern which you can guess: enter 1"
	modeIn=gets.chomp
	if modeIn=="0" || modeIn=="1"
		correctInput=true
	else
		puts "Enter an acceptable input!"
	end
end
mode=modeIn.to_i
if mode==0
	numEach=[nil,nil,nil,nil]
	for i in 0..numEach.length-1
		puts "I guess: "+ "#{i.to_s} "*4+ "\nHow many did I get in the right pos and color?"
		numEach[i]=gets.chomp.to_i
		puts "How about in the right color but not right pos?"
		numEach[i]+=gets.chomp.to_i
	end
	puts "Alright, I've narrowed it down to a few posibilities. I'm going to list them. Thanks for playing!"
	game=Mastermind.new
	game.listPermutations(numEach)
else
	notWon=true
	game = Mastermind.new
	while(notWon)
		puts "Enter in a guess for the first number which will be either 1,2,3,4"
		pos1guess = gets.chomp.to_i
		puts "Enter in a guess for the second number which will be either 1,2,3,4"
		pos2guess = gets.chomp.to_i
		puts "Enter in a guess for the third number which will be either 1,2,3,4"
		pos3guess = gets.chomp.to_i
		puts "Enter in a guess for the fourth number which will be either 1,2,3,4"
		pos4guess = gets.chomp.to_i
		won, rightPos, rightColor = game.checkPattern(pos1guess,pos2guess,pos3guess,pos4guess)
		notWon=!won
		if notWon 
			puts "Number in the right Postition: #{rightPos}\nNumber of the right Color not in the right position:#{rightColor}"
		end
	end
	puts "Game Over!"
end