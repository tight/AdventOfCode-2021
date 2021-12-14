require_relative "spec_helper"

class Polymerization
  attr_reader :polymer

  def initialize(polymer, rules)
    @polymer = polymer
    @rules = rules.map { |(a, b), c| [[a, b], [[a, c], [c, b]]] }.to_h
  end

  def step(n = 1)
    pair_counts = polymer.each_cons(2).to_a.tally
    n.times do
      new_pair_counts = Hash.new(0)
      pair_counts.each do |pair, count|
        rules[pair].each do |new_pair|
          new_pair_counts[new_pair] += count
        end
      end
      pair_counts = new_pair_counts
    end
    @counts = Hash.new(0)
    pair_counts.each do |(_, atom), count|
      @counts[atom] += count
    end
  end

  def most_common_element_count
    counts.max_by { |_, count| count }.last
  end

  def least_common_element_count
    counts.min_by { |_, count| count }.last
  end

  def most_common_minus_least_common_element_count
    most_common_element_count - least_common_element_count
  end

  def to_s
    polymer.join
  end

  private

  attr_reader :rules, :counts
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
    p = Polymerization.new(*example).tap { _1.step(10) }
    expect(p.most_common_element_count).to eql 1749
    expect(p.least_common_element_count).to eql 161
    expect(p.most_common_minus_least_common_element_count).to eql 1588
  end

  specify "part 1 - answer" do
    p = Polymerization.new(*input).tap { _1.step(10) }
    expect(p.most_common_minus_least_common_element_count).to eql 2375
  end

  specify "part 2 - example" do
    p = Polymerization.new(*example).tap { _1.step(40) }
    expect(p.most_common_element_count).to eql 2192039569602
    expect(p.least_common_element_count).to eql 3849876073
    expect(p.most_common_minus_least_common_element_count).to eql 2188189693529
  end

  specify "part 2 - answer" do
    p = Polymerization.new(*input).tap { _1.step(40) }
    expect(p.most_common_minus_least_common_element_count).to eql 1976896901756
  end
end
