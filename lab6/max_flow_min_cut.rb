#!/usr/bin/env ruby
@nodes    = Hash.new { |hash, key| hash[key] = [] }
@flow     = Hash.new { |hash, key| hash[key] = {} }
@capacity = Hash.new { |hash, key| hash[key] = {} }
@names    = []

INFINITY = 1 << 32 #Integer Max value

def max_flow source, sink
  max_flow = 0
  parent = augmenting_path source, sink
  until parent[sink].nil?
    residuals = []
    flow_cap = INFINITY

    #Get bottleneck capacity in path
    where = sink
    until parent[where] == source
      prev = parent[where]
      residuals << @capacity[prev][where] - @flow[prev][where]
      where = parent[where]
    end
    flow_cap = residuals.min
    max_flow += flow_cap

    #Traverse path backwards and set flow
    where = sink
    until parent[where] == source
      prev = parent[where]
      @flow[prev][where] += flow_cap
      @flow[where][prev] -= flow_cap
      where = parent[where]
    end

    parent = augmenting_path source, sink
  end
  max_flow
end

def augmenting_path source, sink
  queue, visited = [source], [source]
  parent = {}
  until queue.empty?
    node = queue.shift
    edges = @nodes[node] - visited
    unless edges.empty?
      edges.each do |e|
        residual = @capacity[node][e] - @flow[node][e]
        if residual > 0
          visited << e
          queue.push(e)
          parent.merge!({e => node})
          if e == sink
            break
          end
        end
      end
    end
  end
  parent
end

def min_cut visited
  min_cut = []
  set = @nodes.keys - visited
  @nodes.each_pair do |node, edges|
    edges.each do |e|
      if visited.include?(node) && set.include?(e)
        min_cut << [node, e, @capacity[node][e]]
      end
    end
  end
  min_cut
end

def flood_fill source
  queue, visited = [source], [source]
  until queue.empty?
    node = queue.shift
    edges = @nodes[node] - visited
    unless edges.empty?
      edges.each do |e|
        residual = @capacity[node][e] - @flow[node][e]
        if residual > 0
          visited << e
          queue.push(e)
        end
      end
    end
  end
  visited
end

def add_edge source, sink, capacity
  @nodes[source] << sink
  @nodes[sink] << source

  @flow[source].merge!({ sink => 0 })
  @flow[sink].merge!({ source => 0 })

  capacity = INFINITY if capacity == -1 #Max int
  @capacity[source].merge!({sink => capacity})
  @capacity[sink].merge!({source => capacity})
end

def parse filepath
  file ||= File.readlines(filepath)

  nodes = file[0].to_i
  1.upto(nodes) { |node| @names << file[node].gsub( "\n", '') }
  connections = file[nodes + 1].to_i + nodes + 1

  (nodes + 2).upto(connections) do |c|
    split = file[c].split.map { |e| e.to_i }
    add_edge(*split)
  end
end

parse ARGV[0]

result = max_flow 0, 54
puts "  Max flow: #{result} \n  Bottleneck arcs:\n"
min_cut = min_cut flood_fill 0
min_cut.each { |c| puts c.join(' ') }
