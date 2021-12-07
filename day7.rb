require_relative "spec_helper"

class Crabs
  def initialize(positions)
    @positions = positions
  end

  def fuel_for(new_position)
    positions.map do |position|
      (new_position - position).abs
    end.sum
  end

  def min_fuel_to_align
    min, max = positions.minmax
    (min..max).map do |position|
      [position, fuel_for(position)]
    end.min_by { _2 }.last
  end

  private

  attr_reader :positions
end

RSpec.describe "Day 7" do
  let(:example) do
    parse_nums(
      <<~INPUT
        16,1,2,0,4,2,7,1,2,14
      INPUT
    )
  end
  let(:input) { parse_nums(File.read("day7_input.txt").split("\n").first) }

  def parse_nums(nums)
    nums.split(",").map(&:to_i)
  end

  describe "Crabs" do
    specify "single crab" do
      expect(Crabs.new([1]).fuel_for(10)).to eql 9
    end

    specify "single crab - reverse" do
      expect(Crabs.new([10]).fuel_for(1)).to eql 9
    end

    specify "several crabs" do
      expect(Crabs.new(example).fuel_for(2)).to eql 37
    end
  end

  specify "part 1 - example" do
    expect(Crabs.new(example).min_fuel_to_align).to eql 37
  end

  specify "part 1 - answer" do
    expect(Crabs.new(input).min_fuel_to_align).to eql 343441
  end

  skip "part 2 - example" do
  end

  skip "part 2 - answer" do
  end
end
