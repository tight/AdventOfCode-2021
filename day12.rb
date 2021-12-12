require_relative "spec_helper"

class Map
  def initialize(connections)
    @connections = connections +
      connections.map do |from, to|
        [to, from] if from != "start" && to != "end"
      end
  end

  def paths_count
    search_paths([["start"]]).count { |path| path.last == "end" }
  end

  private

  attr_reader :connections

  def search_paths(paths)
    founds = []
    paths.each do |path|
      ways = connections
        .select { |from, _| from == path.last }
        .reject { |_, to| small?(to) && path.include?(to) }
      if ways.empty?
        founds << path
      else
        founds += search_paths(ways.map { |from, to| path + [to] })
      end
    end
    founds
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
  let(:input) { parse(File.read("day12_input.txt")) }

  def parse(input)
    input.split("\n").map { _1.split("-") }
  end

  specify "part 1 - example" do
    expect(Map.new(example).paths_count).to eql 10
  end

  specify "part 1 - answer" do
    expect(Map.new(input).paths_count).to eql 4659
  end

  skip "part 2 - example" do
  end

  skip "part 2 - answer" do
  end
end
