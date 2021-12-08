require_relative "spec_helper"

class Display
  attr_reader :out

  def initialize(lines)
    digit_reprs = lines.map { |line| line.scan(/[a-g]+/) }
    @out = digit_reprs.map { _1[-4..] }
  end

  def easy_digit_count
    # digit => segment used
    # 1     => 2
    # 4     => 4
    # 7     => 3
    # 8     => 7
    out.flatten.count { |digit| [2, 4, 3, 7].include?(digit.length) }
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
  end

  specify "part 1 - example" do
    expect(Display.new(example).easy_digit_count).to eql 26
  end

  specify "part 1 - answer" do
    expect(Display.new(input).easy_digit_count).to eql 493
  end

  skip "part 2 - example" do
  end

  skip "part 2 - answer" do
  end
end
