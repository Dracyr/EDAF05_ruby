def build_tree
  @tree = {}
  @words.each do |w|
    @tree[w] = []
    @words.each do |compare|
      contains = (compare.scan(/./).contains_all? w[1..4].scan(/./))
      @tree[w] << compare if (w != compare) and contains
    end
  end
  puts @tree if @debug
  @tree
end

class Array
  def contains_all? other
    other = other.dup
    each{|e| if i = other.index(e) then other.delete_at(i) end}
    other.empty?
  end
end

def build_for node
  neighbours = []
  @words.each do |compare|
    it_contains = (compare.scan(/./).contains_all? node[1..4].scan(/./))
    neighbours << compare if (node != compare) and it_contains
  end
  neighbours
end

def traverse from, to
  queue = [from]
  distance = 0
  visited = []
  while not queue.empty?
    node = queue.shift
  	puts "Halldå där" if visited.include? node
    visited << node
    puts "#{visited}"
    break if node == to
    distance += 1
    edges = build_for node
    unless edges.include? to
      edges -= visited
      visited += edges
      queue << edges unless edges.empty?
      queue.flatten!
    else
      node = to
      break
    end
  end
  distance = -1 unless node == to
  puts distance
end

def readlines filename
  file = File.new(filename)
  lines = file.readlines
end

def parse dat_file, in_file
  @words    = readlines(dat_file).map { |l| l.gsub("\n",'')}
  @words_in = readlines(in_file).map  { |l| l.split }
end

def run
  @words_in.each { |pair| traverse(pair.first, pair.last) }
end

@debug = false
parse ARGV[0], ARGV[1]
run
