require_relative "spec_helper"
def births_at(state, day)
  @cache ||= {}
  @cache[[state, day]] ||= begin
    if day == 0
      1
    else
      if state == 0
        births_at(6, day - 1) + births_at(8, day - 1)
      else
        births_at(state - 1, day - 1)
      end
    end
  end
end

RSpec.describe "Day 6" do
  let(:example) { parse_nums("3,4,3,1,2") }
  let(:input) { parse_nums(File.read("day6_input.txt").lines.first) }

  def parse_nums(nums)
    nums.split(",").map(&:to_i)
  end

  specify ".." do
    expect(example.map { births_at(_1, 18) }.sum).to eql 26
    expect(example.map { births_at(_1, 80) }.sum).to eql 5934
    expect(input.map { births_at(_1, 80) }.sum).to eql 350149
    expect(input.map { births_at(_1, 256) }.sum).to eql 1590327954513
  end
end
