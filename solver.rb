require 'benchmark/ips'

class Rectangle
  attr_reader :arr, :offset

  def initialize(array, offset = 0)
    @offset = offset
    @arr = array
  end

  def width
    @witdh ||= arr.size
  end

  def height
    @h ||= arr.min
  end

  def area
    @area ||= height * width
  end

  def to_s
    "At: #{offset} width: #{width} height: #{height} area: #{area}"
  end

  def max_size
    idx = arr.index(height)
    #sleep 1; puts '%s:%s:%s' % [arr.inspect, offset, idx]
    cmp = [self]
    cmp << Rectangle.new(arr[0..idx-1], offset).max_size if idx > 0
    cmp << Rectangle.new(arr[idx+1..-1], offset + idx + 1).max_size if (idx + 1) < width
    cmp.max { |a,b| a.area <=> b.area }
  end
end

input = [2, 1, 5, 6, 2, 3] # 10
input = [5, 4, 5, 4, 7, 8, 1, 1] # 24
#input = [5, 4, 5, 4, 7, 8, 1, 30] # 30
#input = [5, 4, 5, 4, 31, 8, 1, 30] # 31

# Brute force (super simple)
# "you have got 10 minutes to finish" when original approach is failing on "stack too deep"
def brute_force(input)
  l = 0
  max = Rectangle.new(input)
  r = input.size-1
  (l..r).each do |t_l|
    (t_l..r).each do |t_r|
      temp = Rectangle.new(input[t_l..t_r], t_l)
      max = temp if temp.area > max.area
    end
  end
  max
end

puts brute_force(input)
puts Rectangle.new(input).max_size

Benchmark.ips do |bench|
  bench.report('brute_force') { brute_force(input) }
  bench.report('#max_size') { Rectangle.new(input).max_size }

  bench.compare!
end
