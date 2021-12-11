require_relative "spec_helper"

class Octopuses
  attr_reader :flash_count

  def initialize(lines)
    @levels = {}
    @length = lines.count
    @flash_count = 0
    lines.each_with_index do |line, y|
      line.each_with_index do |level, x|
        @levels[[x, y]] = level
      end
    end
  end

  def after(steps)
    steps.times do
      increase_step
      flash_step
      cleanup_step
    end
  end

  def flash_simultaneously_at
    steps = 0
    while true
      after(1)
      steps += 1
      return steps if levels.all? { |_, level| level == 0 }
    end
  end

  def to_s
    length.times do |y|
      length.times do |x|
        print levels[[x, y]].to_s.rjust(3)
        print " "
      end
      puts ""
    end
  end

  private

  def increase_step
    levels.each do |(x, y), level|
      levels[[x, y]] += 1
    end
  end

  def flash_step
    to_flash.each do |(x, y), _|
      flash(x, y)
    end
  end

  def cleanup_step
    to_flash.each do |(x, y), _|
      levels[[x, y]] = 0
    end
  end

  def flash(x, y)
    @flash_count += 1
    [
      [x - 1, y - 1], [x, y - 1], [x + 1, y - 1],
      [x - 1, y], [x + 1, y],
      [x - 1, y + 1], [x, y + 1], [x + 1, y + 1],
    ].each do |f_x, f_y|
      if levels[[f_x, f_y]]
        levels[[f_x, f_y]] += 1
        flash(f_x, f_y) if levels[[f_x, f_y]] == 10
      end
    end
  end

  def to_flash
    levels.select do |_, level| level > 9 end
  end

  attr_reader :levels, :length
end

RSpec.describe "Day 11" do
  let(:simple_example) do
    parse(
      <<~INPUT
        11111
        19991
        19191
        19991
        11111
      INPUT
    )
  end

  let(:example) do
    parse(
      <<~INPUT
        5483143223
        2745854711
        5264556173
        6141336146
        6357385478
        4167524645
        2176841721
        6882881134
        4846848554
        5283751526
      INPUT
    )
  end
  let(:input) { parse(File.read("day11_input.txt")) }

  def parse(input)
    input.split("\n").map { _1.split("").map(&:to_i) }
  end

  specify "simple example" do
    o = Octopuses.new(simple_example)
    o.after(1)
    expect(o.flash_count).to eql 9
  end

  specify "part 1 - example" do
    o = Octopuses.new(example)
    o.after(10)
    expect(o.flash_count).to eql 204
    o.after(90)
    expect(o.flash_count).to eql 1656
  end

  specify "part 1 - answer" do
    o = Octopuses.new(input)
    o.after(100)
    expect(o.flash_count).to eql 1729
  end

  specify "part 2 - example" do
    o = Octopuses.new(example)
    expect(o.flash_simultaneously_at).to eql 195
  end

  specify "part 2 - answer" do
    o = Octopuses.new(input)
    expect(o.flash_simultaneously_at).to eql 237
  end
end
