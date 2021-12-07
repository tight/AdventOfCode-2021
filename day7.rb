require_relative "spec_helper"

class Crabs
  def initialize(positions)
    @positions = positions
    @cache = {}
  end

  def fuel_for(new_position)
    positions.map do |position|
      fuel_for_distance((new_position - position).abs)
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

  def fuel_for_distance(distance)
    @cache[distance] ||= distance.times.map { _1 + 1 }.to_a.sum
  end
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
    skip "constant fuel rate" do
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

    describe "real fuel rate" do
      specify "single crab" do
        expect(Crabs.new([5]).fuel_for(16)).to eql 66
      end

      specify "single crab - reverse" do
        expect(Crabs.new([16]).fuel_for(5)).to eql 66
      end

      specify "several crabs" do
        expect(Crabs.new(example).fuel_for(2)).to eql 206
      end
    end
  end

  skip "constant fuel rate" do
    specify "part 1 - example" do
      expect(Crabs.new(example).min_fuel_to_align).to eql 37
    end

    specify "part 1 - answer" do
      expect(Crabs.new(input).min_fuel_to_align).to eql 343441
    end
  end

  specify "part 2 - example" do
    expect(Crabs.new(example).min_fuel_to_align).to eql 168
  end

  specify "part 2 - answer" do
    expect(Crabs.new(input).min_fuel_to_align).to eql 98925151
  end
end
