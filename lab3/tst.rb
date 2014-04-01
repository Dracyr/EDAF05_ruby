Duckburg
"Gotham City"
Metropolis
Duckburg--"Gotham City" [2324] 
Duckburg–Metropolis [231] 
“Gotham City”–Metropolis [2298]

@cities = [
	"Duckburg",
	"\"Gotham City\"",
	"Metropolis"
	]

class Node
	attr_accessor :name, :edges

	def initialize name
		self.name = name
		edges = {}
	end

	def add_edge destination, distance
		edges[destination] = distance
	end
end

def run_stuff
	nodes = {}
	db = Node.new("Duckburg")
	gc = Node.new("Gotham City")
	mp = Node.new("Metropolis")
	db.add_edge(gc, 2324)
	db.add_edge(mp, 231)
	gc.add_edge(mp, 2298)
	node["Duckburg", d]
end


def parse input
	if input.matches(/\w+--\w \[\d+\]/)
	
	else #Name
		input.delete!('"')
		city = Node.new(input)
		@Cities[input] = city
	end
end
