class String
  def get_permutations
    char_array = chars.sort
    (0..4).inject([]) do |result, i|
      permutation = char_array.dup
      permutation.delete_at(i)
      result.include?(permutation) ? result : (result << permutation.join)
    end
  end
end

def build_tree
  @buckets = Hash.new { |hash, key| hash[key] = []}
  @words.each do |word|
    word.get_permutations.each do |p|
      @buckets[p] << word
    end
  end
end

def neighbours_for(node)
  if @graph.include? node
    @graph[node]
  else
    key = node[1..4].chars.sort.join
    @graph[node] = @buckets[key] - [node] #Self should not be included in neighbours
  end
end

def traverse(from, to)
  return 0 if from == to
  @graph = {}
  queue      = [from]
  discovered = [from]
  distances  = {from => 0}
  until queue.empty?
    node = queue.shift
    edges = neighbours_for(node) - discovered
    unless edges.empty?
      if edges.include? to
        distances[to] = distances[node] + 1
        break
      else
        discovered += edges
        edges.each { |e| distances[e] = distances[node] + 1}
        queue.push(*edges)
      end
    end
  end
  distances[to] || -1
end

def readlines(filename)
  file = File.new(filename)
  lines = file.readlines
end

def parse(dat_file, in_file)
  @words    = readlines(dat_file).map { |l| l.gsub("\n",'')}
  @words_in = readlines(in_file).map(&:split)
end

@debug = false
parse ARGV[0], ARGV[1]
build_tree
#Run traversal for words
@words_in.each { |pair| puts traverse(pair.first, pair.last) }
