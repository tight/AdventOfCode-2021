require_relative "spec_helper"

def count_increases(string)
  count = 0
  prev = nil
  string.split("\n").map(&:to_i).each do |num|
    count += 1 if prev && prev < num
    prev = num
  end
  count
end

# puts count_increases(File.read("day1_input.txt"))

RSpec.describe "#count_increases" do
  it "works" do
    input = <<~INPUT
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
    expect(count_increases(input)).to eql 7
  end

  it "works #2" do
    expect(count_increases(File.read("day1_input.txt"))).to eql 1624
  end
end
