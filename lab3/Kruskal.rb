class UnionFind
  def initialize
    @leaders = {}
  end

  def add city
  	@leaders[city] = city
  end

  def connected?(city1,city2)
    @leaders[city1] == @leaders[city2]
  end

  def union(city1,city2)
    leader_1, leader_2 = @leaders[city1], @leaders[city2]
    @leaders.each { |city, leader| @leaders[city] = leader_2 if (leader == leader_1)}
  end
end

def file
  @file ||= File.readlines("edges.txt")
end

def run_kruskal
  set = UnionFind.new

  @minimum_spanning_tree = []

  edges = file.drop(1).map { |x| x.gsub(/\n/, "").split(" ").map(&:to_i) }.
    map { |one, two, weight| { :from => one, :to => two, :weight => weight}}.
    sort_by { |x| x[:weight]}

  edges.each do |edge|
    if !set.connected?(edge[:from], edge[:to])
      @minimum_spanning_tree << edge
      set.union(edge[:from], edge[:to])
    end
  end

  puts "MST: #{@minimum_spanning_tree}"
  puts "Cost: #{@minimum_spanning_tree.inject(0) { |acc, x| acc + x[:weight]}}"
end

def read filename
  file = File.new(filename)
  while line = file.gets
    if line.matches(//)
    	
    end
  end
  puts "Datastructure is filled"
end

path = '../testdata/lab3/USA-highway-miles.in'



