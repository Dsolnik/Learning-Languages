def sort(arr)
	if arr.length==2
		return arr[0]<arr[1] ? arr : [arr[1],arr[0]]
	elsif arr.length<2
		return "ERROR"
	elsif arr.length>2
		leftArr=arr.slice(0,arr.length/2)
		rightArr=arr.slice(arr.length/2,arr.length/2)
		left=sort(leftArr)
		right=sort(rightArr)
		final = merge(left,right)
	end
	final
end

def merge(arr_L,arr_R)
	new_Arr=[]
	curr_L=0
	curr_R=0
	i=0
	until new_Arr.length==arr_L.length+arr_R.length
		#if we already added all of the elements in the left array then add the next element from the right array
		if curr_L > arr_L.length-1
			new_Arr[i] = arr_R[curr_R]
			curr_R += 1
		#if we already added all of the elements in the right array then add the next element from the left array
		elsif curr_R > arr_R.length-1
			new_Arr[i] = arr_L[curr_L]
			curr_L += 1
		else
			if arr_L[curr_L] <= arr_R[curr_R]
				new_Arr[i] = arr_L[curr_L]
				curr_L += 1
			else
				new_Arr[i] = arr_R[curr_R]
				curr_R += 1
			end
		end
		i+=1
	end
	new_Arr
end

def rand_arr(n)
	new_arr = []
	n.times{ new_arr.push(rand(100)+1) }
	new_arr
end

def check_sorted(arr)
	sorted=true
	for i in 0..arr.length-2
		sorted=false if arr[i] > arr[i+1]
	end
	if sorted
		puts "SORTED!"
	else
		puts "not sorted :("
	end
end

test_arr= rand_arr(32)
puts test_arr
puts "----"
finalarr = sort(test_arr)
puts finalarr
puts test_arr.length == finalarr.length ? "YES! RIGHT SIZE!" : "no, wrong size ;("
check_sorted(finalarr)