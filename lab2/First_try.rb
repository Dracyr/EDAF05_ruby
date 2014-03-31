class Array
  def contains_all? other
    other = other.dup
    each{|e| if i = other.index(e) then other.delete_at(i) end}
    other.empty?
  end
end

def build_for node
  unless @tree.has_key? node
    neighbours = []
    @words.each do |compare|
      it_contains = (compare.scan(/./).contains_all? node[1..4].scan(/./))
      neighbours << compare if (node != compare) and it_contains
    end
    @tree[node] = neighbours
  else
    @tree[node]
  end
end

def traverse from, to
  @tree = {}
  queue = [from]
  distance = 0
  distances = {}
  distances[from] = 0
  discovered = []
  discovered << from
  until queue.empty?
    node = queue.shift
    #break if node == to
    distance += 1
    edges = build_for node
    if edges.include? to
      node = to
      break
    elsif not edges.empty?
      edges -= discovered
      discovered += edges
      edges.each {|e| distances[e] = distances[node] +1}
      queue = queue | edges
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
