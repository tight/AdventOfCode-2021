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
  MIDDLE_POINTS = {
    ")" => 1,
    "]" => 2,
    "}" => 3,
    ">" => 4,
  }

  def initialize(lines)
    @lines = lines
  end

  def score
    lines.map { line_score(_1) }.sum
  end

  def middle_score
    scores = lines.select { line_score(_1) == 0 }
      .map { autocomplete(_1) }
      .map { autocomplete_score(_1) }
      .sort

    scores[scores.length / 2]
  end

  private

  def autocomplete_score(chars)
    middle_score = 0
    chars.each do |char|
      middle_score *= 5
      middle_score += MIDDLE_POINTS.fetch(char)
    end
    middle_score
  end

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

  def autocomplete(line)
    stack = []
    line.split("").each do |char|
      if ["(", "[", "{", "<"].include? char
        stack << char
      else
        stack.pop
      end
    end
    stack.reverse.map { OPENINGS.invert.fetch(_1) }
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

  specify "part 2 - example" do
    expect(Parser.new(example).middle_score).to eql 288957
  end

  specify "part 2 - answer" do
    expect(Parser.new(input).middle_score).to eql 2776842859
  end
end
