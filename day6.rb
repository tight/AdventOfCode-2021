require_relative "spec_helper"

class Shoal
  attr_reader :counts

  def initialize(states)
    @counts = states.tally
  end

  def wait(days = 1)
    days.times do
      new_counts = Hash.new(0)
      counts.each do |state, count|
        if state == 0
          new_counts[8] += count
          new_counts[6] += count
        else
          new_counts[state - 1] += count
        end
      end
      @counts = new_counts
    end
    self
  end

  def count
    counts.values.sum
  end

  private

  attr_reader :counts
end

RSpec.describe "Day 6" do
  let(:example) { parse_nums("3,4,3,1,2") }
  let(:input) { parse_nums(File.read("day6_input.txt").lines.first) }

  def parse_nums(nums)
    nums.split(",").map(&:to_i)
  end

  describe "computation" do
    specify "simple" do
      s = Shoal.new([5]).wait
      expect(s.count).to eql 1
    end

    specify "birth" do
      s = Shoal.new([0]).wait
      expect(s.count).to eql 2
    end

    specify "several days - simple" do
      s = Shoal.new([5]).wait(2)
      expect(s.count).to eql 1
    end

    specify "several days - birth" do
      s = Shoal.new([0]).wait(2)
      expect(s.count).to eql 2
    end

    specify "severy days - severy births" do
      expect(Shoal.new([0]).wait.count).to eql 2
      expect(Shoal.new([0]).wait(8).count).to eql 3
      expect(Shoal.new([0]).wait(10).count).to eql 4
    end
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

  specify "part 2 - example" do
    s = Shoal.new(example)
    expect(s.wait(256).count).to eql 26_984_457_539
  end

  specify "part 2 - answer" do
    s = Shoal.new(input)
    expect(s.wait(256).count).to eql 1590327954513
  end
end
