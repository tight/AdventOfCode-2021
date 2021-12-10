require_relative "spec_helper"

class Parser
  OPENINGS = {
    ")" => "(",
    "]" => "[",
    "}" => "{",
    ">" => "<"
  }
  POINTS = {
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137,
  }

  def initialize(lines)
    @lines = lines
  end

  def score
    lines.map { line_score(_1) }.sum
  end

  private

  def line_score(line)
    stack = []
    line.split("").each_with_index do |char, index|
      if ["(", "[", "{", "<"].include? char
        stack << char
      else
        if OPENINGS.fetch(char) != stack.last
          # puts line
          # puts "#{" " * (index - 1)} ^"
          # puts "Expected #{stack.last}, got #{char} at #{index}"
          return POINTS[char]
        else
          stack.pop
        end
      end
    end
    return 0
  end

  attr_reader :lines
end

RSpec.describe "Day 10" do
  let(:example) do
    <<~INPUT
      [({(<(())[]>[[{[]{<()<>>
      [(()[<>])]({[<{<<[]>>(
      {([(<{}[<>[]}>{[]{[(<()>
      (((({<>}<{<{<>}{[]{[]{}
      [[<[([]))<([[{}[[()]]]
      [{[{({}]{}}([{[{{{}}([]
      {<[[]]>}<{[{[{[]{()[[[]
      [<(<(<(<{}))><([]([]()
      <{([([[(<>()){}]>(<<{{
      <{([{{}}[<[[[<>{}]]]>[]]
    INPUT
      .split("\n")
  end
  let(:input) { File.read("day10_input.txt").split("\n") }

  specify "part 1 - example" do
    expect(Parser.new(example).score).to eql 26397
  end

  specify "part 1 - answer" do
    expect(Parser.new(input).score).to eql 167379
  end

  skip "part 2 - example" do
  end

  skip "part 2 - answer" do
  end
end
