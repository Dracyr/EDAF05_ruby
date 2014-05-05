class Point
  attr_accessor :id, :x, :y

  def initialize id, x, y
    self.id = id
    self.x = x.to_f
    self.y = y.to_f
  end

  def to_s
    "#{id}, X:#{self.x}, Y:#{self.y}"
  end
end

def distance(p1, p2)
  Math.hypot(p1.x - p2.x, p1.y - p2.y)
end

def closest_bruteforce(points)
  mindist, minpts = Float::MAX, []
  points.length.times do |i|
    (i+1).upto(points.length - 1) do |j|
      dist = distance(points[i], points[j])
      if dist < mindist
        mindist = dist
        minpts = [points[i], points[j]]
      end
    end
  end
  [mindist, minpts]
end

def closest_recursive(points)
  if points.length <= 3
    return closest_bruteforce(points)
  end
  xP = points.sort_by {|p| p.x}
  mid = (points.length / 2.0).ceil
  pL = xP[0,mid]
  pR = xP[mid..-1]
  dL, pairL = closest_recursive(pL)
  dR, pairR = closest_recursive(pR)
  if dL < dR
    dmin, dpair = dL, pairL
  else
    dmin, dpair = dR, pairR
  end
  yP = xP.find_all {|p| (pL[-1].x - p.x).abs < dmin}.sort_by {|p| p.y}
  closest = Float::MAX
  closestPair = []
  0.upto(yP.length - 2) do |i|
    (i+1).upto(yP.length - 1) do |k|
      break if (yP[k].y - yP[i].y) >= dmin
      dist = distance(yP[i], yP[k])
      if dist < closest
        closest = dist
        closestPair = [yP[i], yP[k]]
      end
    end
  end
  if closest < dmin
    [closest, closestPair]
  else
    [dmin, dpair]
  end
end

def parse filepath
  file ||= File.readlines(filepath)

  points = []
  file.each do |line|
    unless (line.strip.empty? || line.include?(':') || line.include?('NODE_COORD_SECTION') || (line.include? 'EOF'))
      points << Point.new(*line.split)
    end
  end
  points
end

path = ARGV[0]
points = parse path

result = closest_recursive(points)
#ps = result[1]
#puts "Points for '#{path.split('/').last}': [#{ps[0].to_s}],[#{ps[1].to_s}], Distance: #{result[0]}"
puts "../data/#{path.split('/').last}: #{points.length} #{result[0]}"

#p ans1 = closest_bruteforce(points)
#p ans2 = closest_recursive(points)
#puts "hoppsan!" if ans1[0] != ans2[0]

#require 'benchmark'
#points = Array.new(10000) {Point.new(1, rand, rand)}
#Benchmark.bm(12) do |x|
#  x.report("bruteforce") {ans1 = closest_bruteforce(points)}
#  x.report("recursive")  {ans2 = closest_recursive(points)}
#end
