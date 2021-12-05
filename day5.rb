require_relative "spec_helper"

class Map
  class Vent
    attr_reader :from_x, :from_y, :to_x, :to_y

    def initialize(vent_str)
      @from_x, @from_y, @to_x, @to_y = vent_str.scan(/\d+/).map(&:to_i)
    end

    def coords
      step_x = step(from_x, to_x)
      step_y = step(from_y, to_y)
      current_coord = [from_x, from_y]
      coords = []
      while current_coord != [to_x, to_y]
        coords << current_coord
        x, y = current_coord
        current_coord = [x + step_x, y + step_y]
      end
      coords << current_coord
      coords
    end

    private

    def step(a, b)
      if a > b
        -1
      elsif a < b
        1
      else
        0
      end
    end
  end

  attr_reader :vents

  def initialize(vents_str)
    @vents = vents_str.map { Vent.new(_1) }
  end

  def overlap_count
    stats = Hash.new(0)

    vents.flat_map(&:coords).each do |x, y|
      stats["#{x}-#{y}"] += 1
    end
    stats.count { |_, count| count > 1 }
  end
end

RSpec.describe "Day 5" do
  let(:example) do
    <<~INPUT
      0,9 -> 5,9
      8,0 -> 0,8
      9,4 -> 3,4
      2,2 -> 2,1
      7,0 -> 7,4
      6,4 -> 2,0
      0,9 -> 2,9
      3,4 -> 1,4
      0,0 -> 8,8
      5,5 -> 8,2
    INPUT
      .split("\n")
  end
  let(:input) { File.read("day5_input.txt").split("\n") }

  describe "Vent" do
    specify "h vent" do
      v = Map::Vent.new("0,9 -> 5,9")
      expect(v.from_x).to eql 0
      expect(v.from_y).to eql 9
      expect(v.to_x).to eql 5
      expect(v.to_y).to eql 9
      expect(v.coords).to match_array [[0, 9], [1, 9], [2, 9], [3, 9], [4, 9], [5, 9]]
    end

    specify "v vent" do
      v = Map::Vent.new("7,0 -> 7,4")
      expect(v.coords).to match_array [[7, 0], [7, 1], [7, 2], [7, 3], [7, 4]]
    end

    specify "h vent reverse" do
      v = Map::Vent.new("5,9 -> 0,9")
      expect(v.coords).to match_array [[0, 9], [1, 9], [2, 9], [3, 9], [4, 9], [5, 9]]
    end

    specify "v vent reverse" do
      v = Map::Vent.new("7,4 -> 7,0")
      expect(v.coords).to match_array [[7, 0], [7, 1], [7, 2], [7, 3], [7, 4]]
    end

    specify "diag" do
      v = Map::Vent.new("0,0 -> 2,2")
      expect(v.coords).to match_array [[0, 0], [1, 1], [2, 2]]
    end

    specify "r diag" do
      v = Map::Vent.new("2,2 -> 0,0")
      expect(v.coords).to match_array [[0, 0], [1, 1], [2, 2]]

      v = Map::Vent.new("8,0 -> 0,8")
      expect(v.coords).to match_array [[8, 0], [7, 1], [6, 2], [5, 3], [4, 4], [3, 5], [2, 6], [1, 7], [0, 8]]
    end
  end

  skip "part 1 - example" do
    map = Map.new(example)
    expect(map.overlap_count).to eql 5
  end

  skip "part 1 - answer" do
    map = Map.new(input)
    expect(map.overlap_count).to eql 4728
  end

  specify "part 2 - example" do
    map = Map.new(example)
    expect(map.overlap_count).to eql 12
  end

  specify "part 2 - answer" do
    map = Map.new(input)
    expect(map.overlap_count).to eql 17717
  end
end
