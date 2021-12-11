require_relative "spec_helper"

class Display
  attr_reader :lines, :out

  def initialize(lines)
    @lines = lines.map { |line| line.scan(/[a-g]+/) }
    @out = @lines.map { _1[-4..] }
  end

  def easy_digit_count
    out.flatten.count { |digit| [2, 4, 3, 7].include?(digit.length) }
  end

  LETTERS_TO_NUMBERS = {
    "abcefg" => 0,
    "cf" => 1,
    "acdeg" => 2,
    "acdfg" => 3,
    "bcdf" => 4,
    "abdfg" => 5,
    "abdefg" => 6,
    "acf" => 7,
    "abcdefg" => 8,
    "abcdfg" => 9,
  }
  VALID_COMBINATIONS = LETTERS_TO_NUMBERS.keys

  def output_sum
    lines.map do |digits|
      output(digits)
    end.sum
  end

  def output(digits)
    one = digits.detect { _1.length == 2 }.split("")
    four = digits.detect { _1.length == 4 }.split("")
    seven = digits.detect { _1.length == 3 }.split("")
    eight = digits.detect { _1.length == 7 }.split("")

    # Déductions possibles
    #
    # 1 = 2 segments =     c     f
    # 4 = 4 segments =   b c d   f
    # 7 = 3 segments = a   c     f
    # 8 = 7 segments = a b c d e f g
    #                  X               7 - 1
    #                      X     X     1
    #                    X   X         4 - 1
    #                          X   X   8 - 7 - 4

    constraints = {}
    constraints[(seven - one).first] = ["a"]
    one.each { constraints[_1] = ["c", "f"] }
    (four - one).each { constraints[_1] = ["b", "d"] }
    (eight - seven - four).each { constraints[_1] = ["e", "g"] }

    "abcdefg".split("").permutation.to_a.each do |letters|
      swaps = "abcdefg".split("").zip(letters).to_h

      respect_contraints = constraints.all? do |from, candidates|
        candidates.include?(swaps[from])
      end

      if respect_contraints
        guess = digits.map { _1.gsub(/./, swaps) }.map { _1.split("").sort.join }
        if guess.all? { VALID_COMBINATIONS.include?(_1) }
          return guess.map { LETTERS_TO_NUMBERS[_1] }.last(4).map(&:to_s).join.to_i
        end
      end
    end
  end
end

RSpec.describe "Day 8" do
  let(:example) do
    <<~INPUT
      be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
      edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
      fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
      fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
      aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
      fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
      dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
      bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
      egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
      gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    INPUT
      .split("\n")
  end
  let(:input) { File.read("day8_input.txt").split("\n") }

  describe "Display" do
    specify "out" do
      expect(Display.new(example).out.first).to eql ["fdgacbe", "cefdb", "cefbgd", "gcbe"]
    end

    specify "easy_digit_count" do
      expect(Display.new([example.first]).easy_digit_count).to eql 2
    end

    specify "output_sum" do
      example2 = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
      expect(Display.new([example2]).output_sum).to eql 5353
    end
  end

  specify "part 1 - example" do
    expect(Display.new(example).easy_digit_count).to eql 26
  end

  specify "part 1 - answer" do
    expect(Display.new(input).easy_digit_count).to eql 493
  end

  specify "part 2 - example" do
    expect(Display.new(example).output_sum).to eql 61229
  end

  specify "part 2 - answer" do
    expect(Display.new(input).output_sum).to eql 1010460
  end
end
