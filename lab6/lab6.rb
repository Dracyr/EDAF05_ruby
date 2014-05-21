#!/usr/bin/env ruby
@nodes = Hash.new { |hash, key| hash[key] = [] }
@flow  = Hash.new { |hash, key| hash[key] = {} }
@capacity = Hash.new { |hash, key| hash[key] = {} }
@names = []

INFINITY = 1073741823

def add_edge source, sink, capacity
  @nodes[source] << sink
  @nodes[sink] << source

  @flow[source].merge!({ sink => 0 })
  @flow[sink].merge!({ source => 0 })

  capacity = 1073741823 if capacity == -1 #Max int
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

def trace from, to, parent
  return [] unless parent[to]
  path = [to]
  edge = to
  until parent[edge] == from
    path.unshift parent[edge]
    edge = parent[edge]
  end
  path.unshift from
  path
end

def augmenting_path source, sink
  return 0 if source == sink
  queue = [source]
  visited = [source]
  parent = {}
  until queue.empty?
    node = queue.shift
    edges = @nodes[node]
    edges -= visited
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
  trace source, sink, parent
end

def max_flow source, sink
  max_flow = 0
  path = augmenting_path source, sink
  until path.empty?
    residuals = []

    flow_cap = INFINITY
    0.upto( path.length - 2 ) do |i|
      u, v = path[i], path[i+1]
      residuals << @capacity[u][v] - @flow[u][v]
    end
    flow_cap = residuals.min
    max_flow += flow_cap

    where = sink
    (path.length - 1).downto(1) do |i|
      prev = path[i - 1]
      @flow[prev][where] += flow_cap
      @flow[where][prev] -= flow_cap
      where = prev
    end
    path = augmenting_path source, sink
  end
  max_flow
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

def min_cut visited
  keys = @nodes.keys
  set = keys
  set -= visited
  min_cut = []
  @nodes.each_pair do |node, edges|
    edges.each do |e|
      if visited.include?(node) && set.include?(e)
        min_cut << [node, e, @capacity[node][e]]
      end
    end
  end
  min_cut
end

parse ARGV[0]

result = max_flow 0, 54
puts "  Max flow: #{result} \n  Bottleneck arcs:\n"
min_cut = min_cut flood_fill 0
min_cut.each { |c| puts c.join(' ') }
