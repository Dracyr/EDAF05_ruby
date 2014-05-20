#!/usr/bin/env ruby

#@names = ["hej", "två", "osv"]
#@nodes = { 'nod1' => { 'nod2' => 'capaticy', 'nod3' => cap }, 'nod2' => { 'nod1' => 'capacity'}}
#@nodes = { |hash, key| hash[key] = {} }
#@flow  = { |hash, key| hash[key] = {} }

#path = "/usr/local/cs/edaf05/lab6/rail.txt"
path = "../testdata/lab6/rail.txt"

@nodes = Hash.new { |hash, key| hash[key] = {} }
@flow  = Hash.new { |hash, key| hash[key] = {} }
@names = []
@capacity = Hash.new { |hash, key| hash[key] = {} }

INFINITY = 1073741823
class Edge
  attr_accessor :source, :sink, :capacity, :back_edge

  def initialize source, sink, capacity
    self.source = source
    self.sink = sink
    if capacity == -1
      self.capacity = INFINITY #Integer max
    else
      self.capacity = capacity
    end
  end

  def eql? other
    self.source    == other.source &&
    self.sink      == other.sink &&
    self.capacity  == other.capacity &&
    self.back_edge == other.back_edge
  end

  def hash
    [self.source, self.sink].hash
  end
end

def add_edge source, sink, capacity
  @nodes[source].merge!({ sink => capacity })
  @nodes[sink].merge!({ source => capacity })

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

def find_path source, sink, path
  return [] if source == sink
  naj = @nodes[source]
  marked = []
  @nodes[source].each do |edge|
    residual = edge.capacity - @flow[edge]
    if residual > 0 && !marked.include?(edge.sink)
      marked << edge.sink
      new_path = path + [edge]
      result = find_path( edge.sink, sink, new_path )
      return result unless result.empty?
    end
  end
  []
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

def augmenting_path from, to
  return 0 if from == to
  queue = [from]
  discovered = [from]
  parent = {}
  until queue.empty?
    node = queue.shift
    edges = @nodes[node].keys
    edges -= discovered
    unless edges.empty?
      if edges.include? to
        parent.merge!( { to => node } )
        break
      else
        discovered += edges
        queue.push(*edges)
        edges.each { |e| parent.merge!({e => node}) }
      end
    end
  end
  trace from, to, parent
end

def max_flow source, sink
  max_flow = 0
  path = augmenting_path source, sink
  until path.empty?
    residuals = []

    0.upto( path.length - 2 ) do |i|
      u, v = path[i], path[i+1]
      residuals << @capacity[u][v] - @flow[u][v]
    end
    flow_min = residuals.min

    max_flow += flow_min
    puts
    if flow_min == 0
      puts "fucked"
      break
    end

    where = sink
    (path.length - 1).downto(1) do |i|
      prev = path[i - 1]
      #puts "#{i}:#{front}:#{back}"
      #puts @flow[front][back]      
      @flow[prev][where] -= flow_min
      @flow[where][prev] += flow_min
      where = prev
    end
    path = augmenting_path source, sink
  end
  [@max_flow, path]
  #@nodes[source].inject(0) { |sum, edge| sum + @flow[edge] }
end

parse path

max_flow 0, 54

