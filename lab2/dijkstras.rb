require 'pqueue'

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

INFINITY = 1 << 32
def traverse from, to
  #puts "from: #{from}"
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
    edges = build_for node
    #puts "edges: #{edges}"
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
  @words_in.each { |pair| traverse(pair.first, pair.last) }
end

@debug = false
parse ARGV[0], ARGV[1]
run


require 'pqueue'

class Algorithm
  INFINITY = 1 << 32

  def self.dijkstra(source, edges, weights, n)
    visited = Array.new(n, false)
    shortest_distances = Array.new(n, INFINITY)
    previous = Array.new(n, nil)
    pq = PQueue.new(proc {|x,y| shortest_distances[x] < shortest_distances[y]})

    pq.push(source)
    visited[source] = true
    shortest_distances[source] = 0

    while pq.size != 0
      v = pq.pop
      visited[v] = true
      if edges[v]
        edges[v].each do |w|
          if !visited[w] and shortest_distances[w] > shortest_distances[v] + weights[v][w]
            shortest_distances[w] = shortest_distances[v] + weights[v][w]
            previous[w] = v
            pq.push(w)
          end
        end
      end
    end
    return [shortest_distances, previous]
  end
end
