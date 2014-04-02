require 'pqueue'

def get_permutations string
  char_array = string.chars.sort
  permutation = []
  i = 0
  while( i < 5 )
    temp_array = char_array.dup
    temp_array.delete_at(i)
    this_permutation = temp_array.join
    permutation << this_permutation unless permutation.include? this_permutation
    i+=1
  end
  permutation
end

def build_tree
  @buckets = {}
  @words.each do |word|
    permutations = get_permutations word
    permutations.each do |p|
      if @buckets.has_key? p
        @buckets[p] << word
      else
        @buckets[p] = [word]
      end
    end
  end
end

def neighbours_for node
  unless @graph.include? node
    key = node[1..4].chars.sort.join
    @graph[node] = @buckets[key] - [node] #Self should not be included in neighbours
  else
    @graph[node]
  end
end

INFINITY = 1 << 32
def traverse from, to
  @tree = {}
  visited = {}
  visited.default(false)
  shortest_distances = {}
  shortest_distances.default = INFINITY
  pq = PQueue.new {|x,y| shortest_distances[x] < shortest_distances[y]}

  pq.push(from)
  visited[from] = true
  shortest_distances[from] = 0
  while pq.size != 0
    print '.'
    node = pq.pop
    visited[node] = true
    edges = neighbours_for node
    unless edges.empty?
      edges.each do |w|
        if shortest_distances[w] > shortest_distances[node] + 1
          shortest_distances[w] = shortest_distances[node] + 1
          pq.push(w)
        end
      end
    end
    if node == to
      break
    end
  end
  if shortest_distances[to] == INFINITY or from == to
    puts (-1)
  else
    puts shortest_distances[to]
  end
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
  @tree = {}
  @words_in.each { |pair| puts traverse(pair.first, pair.last) }
end

@debug = false
parse ARGV[0], ARGV[1]
build_tree
run
