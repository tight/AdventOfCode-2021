require_relative "spec_helper"

Coords = Struct.new(:depth, :horizontal_position, :aim)

def compute_coords(commands)
  coords = Coords.new(0, 0, 0)
  commands.each do |command|
    order, unit = command.split(" ")
    unit = unit.to_i
    if order == "forward"
      coords.horizontal_position += unit
      coords.depth += coords.aim * unit
    elsif order == "down"
      coords.aim += unit
    elsif order == "up"
      coords.aim -= unit
    end
  end
  coords
end

RSpec.describe "Day 2" do
  let(:example) do
    <<~INPUT
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2
    INPUT
  end

  skip "part 1 - example" do
    coords = compute_coords(example.split("\n"))
    expect(coords.depth).to eql 10
    expect(coords.horizontal_position).to eql 15
  end

  skip "part 1 - answer" do
    coords = compute_coords(File.read("day2_input.txt").split("\n"))
    expect(coords.depth).to eql 1091
    expect(coords.horizontal_position).to eql 1927
    expect(coords.depth * coords.horizontal_position).to eql 1091 * 1927 # 2102357
  end

  specify "part 2 - example" do
    coords = compute_coords(example.split("\n"))
    expect(coords.depth).to eql 60
    expect(coords.horizontal_position).to eql 15
  end

  specify "part 2 - answer" do
    coords = compute_coords(File.read("day2_input.txt").split("\n"))
    expect(coords.depth).to eql 1090312
    expect(coords.horizontal_position).to eql 1927
    expect(coords.depth * coords.horizontal_position).to eql 1090312 * 1927 # 2102357
  end
end

# puts compute_coords(File.read("day2_input.txt").split("\n"))
