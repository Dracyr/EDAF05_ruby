#@names = ["hej", "två", "osv"]
@names = []
#@nodes = { 'nod1' => { 'nod2' => 'capaticy', 'nod3' => cap }, 'nod2' => { 'nod1' => 'capacity'}}
@nodes = {}
@nodes = Hash.new { |hash, key| hash[key] = {} }

path = "/usr/local/cs/edaf05/lab6/rail.txt"

def parse filepath
  file ||= File.readlines(filepath)

  nodes = file[0].to_i
  1.upto(nodes) { |node| @names << file[node].gsub( "\n", '') }
  connections = file[nodes + 1].to_i + nodes + 1
  (nodes + 2).upto(connections) do |c|
    split = file[c].split.map { |e| e.to_i }
    @nodes[split[0]].merge!({ split[1] => split[2] })
    @nodes[split[1]].merge!({ split[0] => split[2] })
  end
end

def find_path source, sink
  return [] if source == sink

end

parse path

puts @names.inspect

puts @nodes.inspect
