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
    edges = build_for node
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