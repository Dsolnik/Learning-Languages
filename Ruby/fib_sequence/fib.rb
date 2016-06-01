def fib(n)
	if n==1
		return [1]
	elsif n==2
		return [1,1]
	else
		return fib(n-1).push(fib(n-1)[-1]+fib(n-1)[-2])
	end
end

def printArr(a)
	for i in a
		puts i
	end
end

while(true)
	puts "Enter in how many numbers of the fibbonacci sequence you'd like or a negative number to quit"
	num=gets.chomp.to_i
	if num<0
		break
	end
	puts 
	printArr(fib(num))

end
