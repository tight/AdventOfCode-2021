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
    low_points.values.sum { _1 + 1 }
  end

  def mult_three_largest_bassins
    low_points.map do |(x, y), height|
      bassin_size(x, y, height)
    end.sort.last(3).inject(:*)
  end

  private

  def bassin_size(x, y, height, processed = [])
    processed << [x, y]
    1 + neighboors(x, y).sum do |(neighboor_x, neighboor_y), neighboor_height|
      if (neighboor_height == 9) || (height >= neighboor_height) || processed.include?([neighboor_x, neighboor_y])
        0
      else
        bassin_size(neighboor_x, neighboor_y, neighboor_height, processed)
      end
    end
  end

  def neighboors(x, y)
    {
      [x - 1, y] => heights[[x - 1, y]],
      [x + 1, y] => heights[[x + 1, y]],
      [x, y - 1] => heights[[x, y - 1]],
      [x, y + 1] => heights[[x, y + 1]],
    }.select { _2 }
  end

  def low_points
    heights.select do |(x, y), height|
      neighboors(x, y).all? { |_, neighboor_height| height < neighboor_height }
    end
  end

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

  specify "part 2 - example" do
    expect(HeightMap.new(example).mult_three_largest_bassins).to eql 1134
  end

  specify "part 2 - answer" do
    expect(HeightMap.new(input).mult_three_largest_bassins).to eql 931200
  end
end
