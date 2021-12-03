require_relative "spec_helper"

require "active_support"
require "active_support/core_ext/array"
require "active_support/core_ext/string"

public
def all_equals?(values)
  values.uniq.length == 1
end

def common_bit(bits, comparison_method, default_when_equals)
  counts = bits.tally
  if all_equals?(counts.map(&:second))
    default_when_equals
  else
    counts.public_send(comparison_method, &:second).first
  end
end

def most_common_bit(bits)
  common_bit(bits, :max_by, "1")
end

def least_common_bit(bits)
  common_bit(bits, :min_by, "0")
end

def transpose_strings(arrays)
  arrays.map { |item| item.split("") }.transpose
end

def gamma_rate(bin_numbers)
  transpose_strings(bin_numbers).map { most_common_bit(_1) }.join
end

def epsilon_rate(bin_numbers)
  transpose_strings(bin_numbers).map { least_common_bit(_1) }.join
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

def mult_bin_numbers(a, b)
  a.to_i(2) * b.to_i(2)
end
alias :power_consumption :mult_bin_numbers
alias :life_support_rating :mult_bin_numbers

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
    expect(power_consumption(g, e)).to eql 198
  end

  specify "part 1 - anser" do
    expect(power_consumption(gamma_rate(input), epsilon_rate(input))).to eql 4103154
  end

  specify "part 2 - example" do
    o = oxygen_generator_rating(example)
    c = co2_scrubber_rating(example)
    expect(o).to eql "10111"
    expect(c).to eql "01010"
    expect(life_support_rating(o, c)).to eql 230
  end

  specify "part 2 - answer" do
    o = oxygen_generator_rating(input)
    c = co2_scrubber_rating(input)
    expect(life_support_rating(o, c)).to eql 4245351
  end
end
