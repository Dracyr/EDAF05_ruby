
def read path
	file = File.new(path)
	
	while line = file.gets
		if line.matches(/Dimension rad/)
			dimension = line. #dimension
		end
		if line.matches(/Coord section/)
			#ta bort randomrader
			break
		end
	end

	#mappa rader till array, genom att splitta på whitespace, parsa siffrorna innan kanske?
	edges = line.split.map { |id, xcoord, ycoord| id: id, xcoord: xcoord, ycoord:ycoord }
	point = {id: id, xcoord: x, ycoord: y}


end