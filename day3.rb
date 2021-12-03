require_relative "spec_helper"

require "active_support"
require "active_support/core_ext/array"
require "active_support/core_ext/string"

public
def most_common_bit(bits)
  counts = bits.tally
  if counts.map(&:second).uniq.length == 1
    "1"
  else
    counts.max_by(&:second).first
  end
end

def least_common_bit(bits)
  counts = bits.tally
  if counts.map(&:second).uniq.length == 1
    "0"
  else
    counts.min_by(&:second).first
  end
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

def oxygen_generator_rating(bin_numbers, position = 0)
  rating(bin_numbers, :most_common_bit)
end

def co2_scrubber_rating(bin_numbers, position = 0)
  rating(bin_numbers, :least_common_bit)
end

def rating(bin_numbers, bit_selection_method, position = 0)
  bit = public_send(bit_selection_method, bin_numbers.map { _1[position] })
  new_bin_numbers = bin_numbers.select { _1[position] == bit }
  if bin_numbers.length == 1
    bin_numbers.first
  else
    rating(new_bin_numbers, bit_selection_method, position + 1)
  end
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

  let(:input) { File.read("day3_input.txt").split("\n") }

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

  specify "part 2 - example" do
    expect(oxygen_generator_rating(example)).to eql "10111"
    expect(co2_scrubber_rating(example)).to eql "01010"
  end

  specify "part 2 - answer" do
    expect(oxygen_generator_rating(input).to_i(2) * co2_scrubber_rating(input).to_i(2)).to eql 4245351
  end
end
