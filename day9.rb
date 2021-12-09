require_relative "spec_helper"

class HeightMap
  def initialize(height_lines)
    @heights = {}
    height_lines.each_with_index do |heights, y|
      heights.each_with_index do |height, x|
        @heights[[x, y]] = height
      end
    end
  end

  def risk_levels_sum
    heights.select do |(x, y), height|
      neighboors = [
        heights[[x - 1, y]],
        heights[[x + 1, y]],
        heights[[x, y - 1]],
        heights[[x, y + 1]],
      ]

      neighboors.compact.all? { |neighboor_height| height < neighboor_height }
    end.values.sum { _1 + 1 }
  end

  private

  attr_reader :heights
end

RSpec.describe "Day 9" do
  let(:example) do
    <<~INPUT
      2199943210
      3987894921
      9856789892
      8767896789
      9899965678
    INPUT
      .split("\n")
      .map { parse_nums _1 }
  end
  let(:input) { File.read("day9_input.txt").split("\n").map { parse_nums _1 } }

  def parse_nums(nums)
    nums.split("").map(&:to_i)
  end

  specify "part 1 - example" do
    expect(HeightMap.new(example).risk_levels_sum).to eql 15
  end

  specify "part 1 - answer" do
    expect(HeightMap.new(input).risk_levels_sum).to eql 506
  end

  skip "part 2 - example" do
  end

  skip "part 2 - answer" do
  end
end
