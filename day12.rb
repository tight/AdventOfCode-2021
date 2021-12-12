require_relative "spec_helper"

class Map
  def initialize(connections)
    @connections = connections +
      connections.map do |from, to|
        [to, from] if from != "start" && to != "end"
      end
  end

  def paths_count
    search_paths([["start"]]).count
  end

  private

  attr_reader :connections

  def search_paths(paths)
    founds = []
    paths.each do |path|
      if path.last == "end"
        founds << path
      else
        ways = connections
          .select { |from, _| from == path.last }
          .reject { |_, to| (to == "start") || (small?(to) && path.count(to) > 1) }
          .select { |_, to| valid_small_caves_visits?(path + [to]) }
        founds += search_paths(ways.map { |from, to| path + [to] })
      end
    end
    founds
  end

  def valid_small_caves_visits?(path)
    counts = path.select { small?(_1) }.tally
    (counts.count { |_, count| count == 2 }) <= 1
  end

  def small?(str)
    str.downcase == str
  end
end

RSpec.describe "Day 12" do
  let(:example) do
    parse(
      <<~INPUT
        start-A
        start-b
        A-c
        A-b
        b-d
        A-end
        b-end
      INPUT
    )
  end
  let(:slightly_larger_example) do
    parse(
      <<~INPUT
        dc-end
        HN-start
        start-kj
        dc-start
        dc-HN
        LN-dc
        HN-end
        kj-sa
        kj-HN
        kj-dc
      INPUT
    )
  end
  let(:even_larger_example) do
    parse(
      <<~INPUT
        fs-end
        he-DX
        fs-he
        start-DX
        pj-DX
        end-zg
        zg-sl
        zg-pj
        pj-he
        RW-he
        fs-DX
        pj-RW
        zg-RW
        start-pj
        he-WI
        zg-he
        pj-fs
        start-RW
      INPUT
    )
  end
  let(:input) { parse(File.read("day12_input.txt")) }

  def parse(input)
    input.split("\n").map { _1.split("-") }
  end

  skip "part 1 - example" do
    expect(Map.new(example).paths_count).to eql 10
  end

  skip "part 1 - answer" do
    expect(Map.new(input).paths_count).to eql 4659
  end

  specify "part 2 - example" do
    expect(Map.new(example).paths_count).to eql 36
  end

  specify "part 2 - slightly larger example" do
    expect(Map.new(slightly_larger_example).paths_count).to eql 103
  end

  specify "part 2 -  even larger example" do
    expect(Map.new(even_larger_example).paths_count).to eql 3509
  end

  specify "part 2 - answer" do
    expect(Map.new(input).paths_count).to eql 148962
  end
end
