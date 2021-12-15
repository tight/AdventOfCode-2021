require_relative "spec_helper"

class Weights
  attr_reader :start, :weights, :map

  def initialize(start, map)
    @start = start
    @weights = {}
    @weights[start] = 0
    @map = map
  end

  def compute
    to_compute = [start]
    while to_compute.any?
      puts to_s
      puts "***"
      new_to_compute = []
      to_compute.each do |cell|
        x, y = cell
        [[x, y - 1], [x - 1, y], [x + 1, y], [x, y + 1]].each do |dest|
          next unless map[dest]
          new_weight = weights[cell] + map[dest]
          next if weights[dest] && weights[dest] < new_weight
          weights[dest] = new_weight
          new_to_compute << dest
        end
      end
      to_compute = new_to_compute
    end
    self
  end

  def to_s
    str = ""
    size = map.max_by { |(x, y), _| x }.first.first
    (size + 1).times do |y|
      (size + 1).times do |x|
        num = weights[[x, y]].to_s.rjust(2)
        str += "#{num} "
      end
      str += "\n"
    end
    str
  end
end

class RiskLevelMap
  def initialize(lines)
    @levels = {}
    lines.each_with_index do |cols, y|
      cols.each_with_index do |level, x|
        @levels[[x, y]] = level
      end
    end
    @size = lines.length
  end

  def lowest_risk_path_risk
    weights = Weights.new([0, 0], levels).compute
    weights.weights[[size - 1, size - 1]]
  end

  private

  attr_reader :levels, :size
end

RSpec.describe "Day 15" do
  let(:example) do
    parse(
      <<~INPUT
        1163751742
        1381373672
        2136511328
        3694931569
        7463417111
        1319128137
        1359912421
        3125421639
        1293138521
        2311944581
      INPUT
    )
  end
  let(:input) { parse(File.read("day15_input.txt")) }

  def parse(input)
    input.split("\n").map { _1.split("").map(&:to_i) }
  end

  specify "part 1 - example", :focus do
    expect(RiskLevelMap.new(example).lowest_risk_path_risk).to eql 40
  end

  specify "part 1 - answer" do
    expect(RiskLevelMap.new(input).lowest_risk_path_risk).to eql 40
  end

  skip "part 2 - example" do
  end

  skip "part 2 - answer" do
  end
end
