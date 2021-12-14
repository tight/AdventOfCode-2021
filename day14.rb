require_relative "spec_helper"

class Polymerization
  attr_reader :polymer

  def initialize(polymer, rules)
    @polymer = polymer
    @rules = rules
  end

  def step(n = 1)
    n.times do
      new_polymer = [polymer.first]
      polymer.each_cons(2).each do |(a, b)|
        new_polymer << [rules.fetch([a, b]), b]
      end
      @polymer = new_polymer.flatten
    end
  end

  def most_common_element_count
    polymer.tally.max_by { _2 }.last
  end

  def least_common_element_count
    polymer.tally.min_by { _2 }.last
  end

  def most_common_minus_least_common_element_count
    most_common_element_count - least_common_element_count
  end

  def to_s
    polymer.join
  end

  private

  attr_reader :rules
end

RSpec.describe "Day 14" do
  let(:example) do
    parse(
      <<~INPUT
        NNCB

        CH -> B
        HH -> N
        CB -> H
        NH -> C
        HB -> C
        HC -> B
        HN -> C
        NN -> C
        BH -> H
        NC -> B
        NB -> B
        BN -> B
        BB -> N
        BC -> B
        CC -> N
        CN -> C
      INPUT
    )
  end
  let(:input) { parse(File.read("day14_input.txt")) }

  def parse(input)
    polymer, rules = input.split("\n\n")
    [
      polymer.split(""),
      rules.split("\n").map do |rule|
        froms, to = rule.scan(/[A-Z]+/)
        [froms.split(""), to]
      end.to_h
    ]
  end

  specify "part 1 - example" do
    expect(Polymerization.new(*example).tap(&:step).to_s).to eql "NCNBCHB"
    expect(Polymerization.new(*example).tap { _1.step(2) }.to_s).to eql "NBCCNBBBCBHCB"
    expect(Polymerization.new(*example).tap { _1.step(3) }.to_s).to eql "NBBBCNCCNBBNBNBBCHBHHBCHB"
    expect(Polymerization.new(*example).tap { _1.step(4) }.to_s).to eql "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB"
    p = Polymerization.new(*example).tap { _1.step(10) }
    expect(p.most_common_element_count).to eql 1749
    expect(p.least_common_element_count).to eql 161
    expect(p.most_common_minus_least_common_element_count).to eql 1588
  end

  specify "part 1 - answer" do
    p = Polymerization.new(*input).tap { _1.step(10) }
    expect(p.most_common_minus_least_common_element_count).to eql 2375
  end

  skip "part 2 - example" do
  end

  skip "part 2 - answer" do
  end
end
