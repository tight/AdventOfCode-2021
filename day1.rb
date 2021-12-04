require_relative "spec_helper"

def count_increases(nums)
  count = 0
  prev = nil
  nums.each do |num|
    count += 1 if prev && prev < num
    prev = num
  end
  count
end

def sum_by_window(nums)
  nums.each_cons(3).map do |window|
    window.sum
  end
end

def read_nums_from_string(string)
  string.split("\n").map(&:to_i)
end

# puts count_increases(File.read("day1_input.txt"))
# puts count_increases(sum_by_window(read_nums_from_string(File.read("day1_input.txt"))))

RSpec.describe "Day 1" do
  let(:example) do
    <<~INPUT
      199
      200
      208
      210
      200
      207
      240
      269
      260
      263
    INPUT
  end

  describe "#sum_by_window" do
    it "works" do
      expect(sum_by_window([1, 2, 3, 4])).to eql [1 + 2 + 3, 2 + 3 + 4]
    end
  end

  specify "part 1 - example" do
    expect(count_increases(read_nums_from_string(example))).to eql 7
  end

  specify "part 1 - answer" do
    expect(count_increases(read_nums_from_string(File.read("day1_input.txt")))).to eql 1624
  end

  specify "part 2 - example" do
    expect(count_increases(sum_by_window(read_nums_from_string(example)))).to eql 5
  end

  specify "part 2 - answer" do
    expect(count_increases(sum_by_window(read_nums_from_string(File.read("day1_input.txt"))))).to eql 1653
  end
end
