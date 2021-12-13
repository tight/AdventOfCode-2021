require_relative "spec_helper"

class Paper
  def initialize(dots, folds, width = nil, height = nil)
    @dots = dots
    @folds = folds
    @width = width || compute_width
    @height = height || compute_height
  end

  def dots_count
    folds.each do |(axe, fold_at)|
      fold(axe, fold_at)
    end
    dots.count
  end

  def to_s
    str = ""
    height.times do |y|
      width.times do |x|
        if dots.include?([x, y])
          str += "#"
        else
          str += "."
        end
      end
      str += "\n"
    end
    str
  end

  private

  attr_reader :dots, :folds, :width, :height

  def compute_width
    dots.map { |(x, _)| x }.max + 1
  end

  def compute_height
    dots.map { |(_, y)| y }.max + 1
  end

  def fold(axe, fold_at)
    if axe == "y"
      first_part = dots.select { |(x, y)| y <= fold_at }
      second_part = dots.select { |(x, y)| y > fold_at }
        .map { |(x, y)| [x, y - fold_at - 1] }
        .map { |(x, y)| [x, fold_at - y - 1] }

      initialize((first_part + second_part).uniq, [], width, height / 2)
    elsif axe == "x"
      transpose
      fold("y", fold_at)
      transpose
    end
  end

  def transpose
    @dots = dots.map { |(x, y)| [y, x] }
    tmp = width
    @width = height
    @height = tmp
  end
end

RSpec.describe "Day 13" do
  let(:example) do
    parse(
      <<~INPUT
        6,10
        0,14
        9,10
        0,3
        10,4
        4,11
        6,0
        6,12
        4,1
        0,13
        10,12
        3,4
        3,0
        8,4
        1,10
        2,14
        8,10
        9,0

        fold along y=7
        fold along x=5
      INPUT
    )
  end
  let(:input) { parse(File.read("day13_input.txt")) }

  def parse(input)
    dots_part, folds_part = input.split("\n\n")
    [
      dots_part.split("\n").map { _1.split(",").map(&:to_i) },
      folds_part.scan(/fold along (x|y)=(\d+)/).map { |axe, fold_at| [axe, fold_at.to_i] }
    ]
  end

  specify "part 1 - example" do
    dots, folds = example
    expect(Paper.new(dots, [folds.first]).dots_count).to eql 17
    expect(Paper.new(dots, folds).dots_count).to eql 16
  end

  specify "part 1 - answer" do
    dots, folds = input
    folds = [folds.first]
    expect(Paper.new(dots, folds).dots_count).to eql 745
  end

  skip "part 2 - example" do
  end

  skip "part 2 - answer" do
  end
end
