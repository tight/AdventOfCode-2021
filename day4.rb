require_relative "spec_helper"

require "active_support"
require "active_support/core_ext/array"

class Bingo
  class ThatsABingo < StandardError
  end

  Cell = Struct.new(:number, :found) do
    def draw_number!(drawn_number)
      if number == drawn_number
        self.found = true
      end
    end

    def found?
      !!found
    end
  end

  class Grid
    attr_reader :lines

    def initialize(lines)
      @lines = lines.map do |numbers|
        line = numbers.map { Cell.new(_1) }
      end
    end

    def draw_number!(number)
      lines.each do |cells|
        cells.each do |cell|
          cell.draw_number!(number)
        end
      end

      if lines.any? { _1.all?(&:found?) } || cols.any? { _1.all?(&:found?) }
        raise ThatsABingo.new
      end
    end

    def score
      sum = 0
      lines.each do |cells|
        cells.each do |cell|
          sum += cell.number unless cell.found?
        end
      end
      sum
    end

    def cols
      lines.transpose
    end

    def to_a
      lines.map do |cells|
        cells.map(&:number)
      end
    end
  end

  Metadata = Struct.new(:grid, :last_number, :turn)

  attr_reader :numbers, :grids

  def initialize(input)
    @numbers = input.shift.split(",").map(&:to_i)

    input.shift

    @grids = input # ["1 2", "3 4", "", "5 6", "7 8"]
      .chunk { _1 == "" } # [[false, ["1 2", "3 4"]], [true, [""]], [false, ["5 6", "7 8"]]]
      .reject { |k, _| k } # [[false, ["1 2", "3 4"]], [false, ["5 6", "7 8"]]]
      .map { |_, lines| lines.map { |line| line.split(" ").map(&:to_i) } } # [[[1, 2], [3, 4]], [[5, 6], [7, 8]]]
      .map { Grid.new(_1) } # [Grid.new([[1, 2], [3, 4]), Grid.new([[5, 6], [7, 8]])]
  end

  def draw_numbers!
    @grid_metadatas = []
    grids.each do |grid|
      grid_metadatas << draw_numbers_on(grid)
    end
  end

  def loosing_grid_metadata
    grid_metadatas.max_by { _1.turn }
  end

  def winning_grid_metadata
    grid_metadatas.min_by { _1.turn }
  end

  def winning_grid_score
    winning_grid_metadata.grid.score
  end

  def winning_grid_last_number_called
    winning_grid_metadata.last_number
  end

  def winning_grid_final_score
    winning_grid_score * winning_grid_last_number_called
  end

  def loosing_grid_score
    loosing_grid_metadata.grid.score
  end

  def loosing_grid_last_number_called
    loosing_grid_metadata.last_number
  end

  def loosing_grid_final_score
    loosing_grid_score * loosing_grid_last_number_called
  end

  private

  attr_reader :grid_metadatas

  def draw_numbers_on(grid)
    numbers.each_with_index do |number, index|
      begin
        grid.draw_number!(number)
      rescue ThatsABingo
        return Metadata.new(grid, number, index)
      end
    end
  end
end

RSpec.describe "Day 4" do
  let(:example) do
    <<~INPUT
      7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

      22 13 17 11  0
      8  2 23  4 24
      21  9 14 16  7
      6 10  3 18  5
      1 12 20 15 19

      3 15  0  2 22
      9 18 13 17  5
      19  8  7 25 23
      20 11 10 24  4
      14 21 16 12  6

      14 21 17 24  4
      10 16 15  9 19
      18  8 23 26 20
      22 11 13  6  5
      2  0 12  3  7
    INPUT
      .split("\n")
  end
  let(:input) { File.read("day4_input.txt").split("\n") }

  describe "grid" do
    let(:grid) { Bingo::Grid.new([[1, 2], [3, 4]]) }

    specify "draw number" do
      expect {
        grid.draw_number!(4)
      }.to change {
        grid.lines[1][1].found?
      }.from(false).to(true)
    end

    specify "bingo line" do
      grid.draw_number!(1)
      expect {
        grid.draw_number!(2)
      }.to raise_error(Bingo::ThatsABingo)
    end

    specify "bingo col" do
      grid.draw_number!(2)
      expect {
        grid.draw_number!(4)
      }.to raise_error(Bingo::ThatsABingo)
    end
  end

  specify "part 1 - example" do
    bingo = Bingo.new(example)
    expect(bingo.numbers).to eql [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24, 10, 16, 13, 6, 15, 25, 12, 22, 18, 20, 8, 19, 3, 26, 1]
    expect(bingo.grids.map(&:to_a)).to eql [
      [
        [22, 13, 17, 11, 0],
        [8, 2, 23, 4, 24],
        [21, 9, 14, 16, 7],
        [6, 10, 3, 18, 5],
        [1, 12, 20, 15, 19],
      ],

      [
        [3, 15, 0, 2, 22],
        [9, 18, 13, 17, 5],
        [19, 8, 7, 25, 23],
        [20, 11, 10, 24, 4],
        [14, 21, 16, 12, 6],
      ],

      [
        [14, 21, 17, 24, 4],
        [10, 16, 15, 9, 19],
        [18, 8, 23, 26, 20],
        [22, 11, 13, 6, 5],
        [2, 0, 12, 3, 7],
      ]
    ]

    bingo.draw_numbers!
    expect(bingo.winning_grid_last_number_called).to eql 24
    expect(bingo.winning_grid_score).to eql 188
    expect(bingo.winning_grid_final_score).to eql 4512
  end

  specify "part 1 - answer" do
    bingo = Bingo.new(input).tap(&:draw_numbers!)
    expect(bingo.winning_grid_final_score).to eql 69579
  end

  specify "part 2 - example" do
    bingo = Bingo.new(example)
    bingo.draw_numbers!
    expect(bingo.loosing_grid_score).to eql 148
    expect(bingo.loosing_grid_last_number_called).to eql 13
    expect(bingo.loosing_grid_final_score).to eql 1924
  end

  specify "part 2 - answer" do
    bingo = Bingo.new(input)
    bingo.draw_numbers!
    expect(bingo.loosing_grid_final_score).to eql 14877
  end
end
