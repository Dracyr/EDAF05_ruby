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
  min_dist = Float::MAX
  points.length.times do |i|
    (i+1).upto(points.length - 1) do |j|
      dist = points[i].distance_to points[j]
      min_dist = dist if dist < min_dist
    end
  end
  min_dist
end

def closest_recursive(points)
  return closest_bruteforce(points) if points.length <= 3

  points = points.sort_by {|p| p.x}
  mid = (points.length / 2)
  points_left = points[0,mid]

  left = closest_recursive(points_left)
  right = closest_recursive(points[mid..-1])

  min_dist = [left, right].min

  yP = points.find_all { |p| (points_left[-1].x - p.x).abs < min_dist}.sort_by(&:y)
  closest = Float::MAX
  0.upto(yP.length - 1) do |i|
    (i+1).upto(yP.length - 1) do |k|
      break if (yP[k].y - yP[i].y) >= min_dist
      dist = yP[i].distance_to yP[k]
      closest = dist if dist < closest
    end
  end
  closest < min_dist ? closest : min_dist
end

def parse filepath
  file ||= File.readlines(filepath)
  points = []
  file.each do |line|
    points << Point.new(*line.split) unless (line.split.length != 3) || line.include?(':')
  end
  points
end

path = ARGV[0]
if path.split('.').last == "tsp"
  points = parse path

  result = closest_recursive(points)
  result = result.to_i if result % 1 == 0
  puts "../data/#{path.split('/').last}: #{points.length} #{result}"
end
