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
      unless node == compare
        neighbours << compare if (compare.scan(/./).contains_all? node[1..4].scan(/./))
      end
    end
    @tree[node] = neighbours
  else
    @tree[node]
  end
end

def traverse from, to
  return 0 if from == to
  queue = [from]
  discovered = [from]
  distances = { from => 0 }
  until queue.empty?
    node = queue.shift
    edges = build_for node
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
run
