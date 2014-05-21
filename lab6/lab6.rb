#!/usr/bin/env ruby

#@names = ["hej", "två", "osv"]
#@nodes = { 'nod1' => { 'nod2' => 'capaticy', 'nod3' => cap }, 'nod2' => { 'nod1' => 'capacity'}}
#@nodes = { |hash, key| hash[key] = {} }
#@flow  = { |hash, key| hash[key] = {} }

#path = "/usr/local/cs/edaf05/lab6/rail.txt"
path = "../testdata/lab6/rail.txt"

@nodes = Hash.new { |hash, key| hash[key] = [] }
@flow  = Hash.new { |hash, key| hash[key] = {} }
@names = []
@capacity = Hash.new { |hash, key| hash[key] = {} }

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
  #parent
  trace source, sink, parent
end

def max_flow source, sink
  max_flow = 0
  min_cut = []
  path = augmenting_path source, sink
  until path.empty?

    flow_cap = INFINITY
    bottleneck = []
    0.upto( path.length - 2 ) do |i|
      u, v = path[i], path[i+1]
      residual = @capacity[u][v] - @flow[u][v]
      if residual < flow_cap
        flow_cap = residual
        bottleneck = [u,v, @capacity[u][v]]
      end
    end
    max_flow += flow_cap
    #asd = bottleneck << flow_cap
    min_cut << bottleneck

    where = sink
    (path.length - 1).downto(1) do |i|
      prev = path[i - 1]
      @flow[prev][where] += flow_cap
      @flow[where][prev] -= flow_cap
      where = prev
    end
    path = augmenting_path source, sink
  end
  [max_flow, min_cut]
  #@nodes[source].inject(0) { |sum, edge| sum + @flow[edge] }
end

def min_cut_stuff
  @nodes.each_pair do |key, value|


  end

end

parse path

result = max_flow 0, 54
puts "Max flow: #{result.first}"
min_cut = result.last
min_cut.each { |c| puts c.inspect }
