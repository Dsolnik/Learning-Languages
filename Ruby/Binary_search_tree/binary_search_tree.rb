class Node

	attr_accessor :value, :parent, :left, :right

	def initialize(value, parent=nil)
		@value = value
		@parent = parent
	end

	def to_s
		print @left if left
		print value
		print @right if right
	end

end

class Tree

	attr_accessor :root

	def build_tree(arr)
		@root = Node.new(arr[0])
		curr_node = @root
		for val in arr[1..-1]
			set = false
			while not set
				if val < curr_node.value
					#if it's less than, check if there's an open slot left to put a node
					#if not, move to that node and check again
					if curr_node.left == nil
						curr_node.left = Node.new(val,curr_node)
						set = true
					else
						curr_node = curr_node.left
					end
				else
					#if it's greater than, check if there's an open slot to put a node
					#if not, move to that node and check again
					if curr_node.right == nil
						curr_node.right = Node.new(val,curr_node)
						set = true
					else
						curr_node = curr_node.right
					end
				end
			end
		end
	end

	def to_s(node = @root)
		to_s(node.left) if node.left
		puts node.value.to_s
		to_s(node.right) if node.right 
	end

	def breath_first_search(target)
		#initial check
		return @root if @root.value == target
		queue = [@root]
		while(queue.length > 0)
			curr_node=queue[0]
			#check current node
			return curr_node.left if curr_node.left.value == target
			return curr_node.right if curr_node.right.value == target
			#push two siblings to queue
			queue.push(curr_node.left) if curr_node.left
			queue.push(curr_node.right) if curr_node.right
			#delete current node from queue
			queue.delete_at(0)
		end
		return nil
	end

	def depth_first_search(target)
		#initial check
		return @root if @root.value == target
		stack=[@root]
		while(stack.length > 0)
			#if it has a left, go deeper
			if stack[0].left
				stack.push(stack[0].left)
				return stack[0].left if stack[0].left.value == target
			#if it has no left, check if it has an alternative to go
			elsif stack[0].right
				stack.push(stack[0].right)
				return stack[0].right if stack[0].right.value == target
			#otherwise, we're at the bottom of the tree and need to go up
			#one and check the previous sub-tree's right portion
			else
			stack.pop
			end
		end
		return nil
	end

	def dfs_rec(curr_node = @branch, target)
		#check current sub-tree for right node
		return curr_node if curr_node.value == target
		return curr_node.left if curr_node.left.value == target
		return curr_node.right.value if curr_node.right.value == target
		#otherwise check left sub-sub-tree
		found_node = dfs_rec(curr_node.left, target) if curr_node.left
		return found_node if found_node
		#otherwise check right sub-sub-tree
		found_node = dfs_rec(curr_node.right, target) if curr_node.right
		nil
	end

end

tree = Tree.new
tree.build_tree([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
puts tree.to_s