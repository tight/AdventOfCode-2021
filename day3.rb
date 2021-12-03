require_relative "spec_helper"

require "active_support"
require "active_support/core_ext/array"

def most_common_bit(bits)
  bits.tally.max_by(&:second).first
end

def least_common_bit(bits)
  bits.tally.min_by(&:second).first
end

def gamma_rate(bin_numbers)
  bin_numbers.first.length.times.map do |position|
    most_common_bit(bin_numbers.map { _1[position] })
  end.join
end

def epsilon_rate(bin_numbers)
  bin_numbers.first.length.times.map do |position|
    least_common_bit(bin_numbers.map { _1[position] })
  end.join
end

RSpec.describe "Day 3" do
  let(:example) do
    <<~INPUT
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
    INPUT
      .split("\n")
  end

  specify "part 1 - example" do
    g = gamma_rate(example)
    e = epsilon_rate(example)
    expect(g).to eql "10110"
    expect(e).to eql "01001"
    dec_g = g.to_i(2)
    dec_e = e.to_i(2)
    expect(dec_g).to eql 22
    expect(dec_e).to eql 9
    expect(dec_g * dec_e).to eql 198
  end

  specify "part 1 - anser" do
    input = File.read("day3_input.txt").split("\n")
    g = gamma_rate(input)
    e = epsilon_rate(input)
    dec_g = g.to_i(2)
    dec_e = e.to_i(2)
    expect(dec_g * dec_e).to eql 4103154
  end
end
