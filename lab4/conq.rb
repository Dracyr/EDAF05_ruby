class Point
  attr_accessor :id, :x, :y

  def initialize id, x, y
    self.id = id
    self.x = x.to_f
    self.y = y.to_f
  end

  def distance_to(point)
    Math.hypot(self.x - point.x, self.y - point.y)
  end
end

def closest_bruteforce(points)
  mindist, minpts = Float::MAX, []
  points.length.times do |i|
    (i+1).upto(points.length - 1) do |j|
      dist = points[i].distance_to points[j]
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
  points.sort_by! {|p| p.x}
  mid = (points.length / 2)
  points_left = points[0,mid]
  points_right = points[mid..-1]

  min_left, pair_left = closest_recursive(points_left)
  min_right, pair_right = closest_recursive(points_right)

  if min_left < min_right
    min_dist, min_pair = min_left, pair_left
  else
    min_dist, min_pair = min_right, pair_right
  end

  yP = points.find_all {|p| (points_left[-1].x - p.x).abs < min_dist}.sort_by {|p| p.y}
  closest = Float::MAX
  closestPair = []
  0.upto(yP.length - 2) do |i|
    (i+1).upto(yP.length - 1) do |k|
      break if (yP[k].y - yP[i].y) >= min_dist
      dist = yP[i].distance_to yP[k]
      if dist < closest
        closest = dist
        closestPair = [yP[i], yP[k]]
      end
    end
  end
  if closest < min_dist
    [closest, closestPair]
  else
    [min_dist, min_pair]
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
