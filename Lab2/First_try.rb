@words = [
	there,
	which,
	their,
	about,
	these,
	words,
	would,
	other,
	write,
	could
]

@words_in = [
	[other, there],
	[other, their],
	[could, would],
	[would, could],
	[there, other],
	[about, there]
]

def build_tree
	@tree = {}	
	@words.each do |w|
		tree[w] = []
		@words.each do |c|
			w_char_array= w[1..4].each_char.to_a
			link = true
			char_array.each do |c|
				unless w.include? c
					link = false
					break;
				end
			end
			@tree[w] << c if link
		end	
	end		
end
