require_relative "spec_helper"

class Shoal
  attr_reader :states

  def initialize(states)
    @states = states
  end

  def wait(days = 1)
    days.times do
      @states = states.flat_map do |state|
        state == 0 ? [6, 8] : state - 1
      end
    end
    self
  end

  def count
    states.count
  end
end

RSpec.describe "Day 6" do
  let(:example) { parse_nums("3,4,3,1,2") }
  let(:input) { parse_nums(File.read("day6_input.txt").lines.first) }

  def parse_nums(nums)
    nums.split(",").map(&:to_i)
  end

  specify "states" do
    expect(Shoal.new([5]).wait.states).to eql [4]
    expect(Shoal.new([0]).wait.states).to eql [6, 8]
    expect(Shoal.new([5]).wait(2).states).to eql [3]
    expect(Shoal.new([0]).wait(2).states).to eql [5, 7]
  end

  specify "part 1 - example" do
    s = Shoal.new(example)
    expect(s.wait(18).count).to eql 26
    expect(s.wait(80 - 18).count).to eql 5934
  end

  specify "part 1 - answer" do
    s = Shoal.new(input)
    expect(s.wait(80).count).to eql 350149
  end

  skip "part 2 - example" do
  end

  skip "part 2 - answer" do
  end
end
