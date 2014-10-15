#!/usr/bin/env ruby
class UnionFind
  def initialize
    @leaders = Hash.new { |hash, key| hash[key] = key }
  end

  def connected?(city1, city2)
    @leaders[city1] == @leaders[city2]
  end

  def union(city1, city2)
    leader_1, leader_2 = @leaders[city1], @leaders[city2]
    @leaders.each { |city, leader| @leaders[city] = leader_2 if (leader == leader_1)}
  end
end

def run_kruskal
  set = UnionFind.new
  edges = []

  @file.each do |line|
    if line.include? '--'
      weight = line.slice!(/ \[\d+\]/).slice(/\d+/).to_i
      cities = line.split("--")
      edges << {from:   cities.first,
                to:     cities.last.gsub(/\n/, ""),
                weight: weight}
    end
  end
  edges = edges.sort_by({ |x| x[:weight] })

  minimum_spanning_tree = []
  edges.each do |edge|
    unless set.connected?(edge[:from], edge[:to])
      minimum_spanning_tree << edge
      set.union(edge[:from], edge[:to])
    end
  end

  #puts "MST: #{minimum_spanning_tree}"
  puts "Cost: #{minimum_spanning_tree.inject(0) { |res, x| res + x[:weight]}}"
end

def read filepath
  @file ||= File.readlines(filepath)
end

read ARGV[0]
run_kruskal
