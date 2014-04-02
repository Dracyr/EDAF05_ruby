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

def traverse from, to
  return 0 if from == to
  @graph = {}
  queue = [from]
  discovered = [from]
  distances = { from => 0 }
  until queue.empty?
    node = queue.shift
    edges = neighbours_for node
    edges -= discovered
    unless edges.empty?
      if edges.include? to
        distances[to] = distances[node] + 1
        break
      else
        discovered += edges
        edges.each {|e| distances[e] = distances[node] +1}
        queue.push(*edges)
      end
    end
  end
  distances[to] || -1
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
