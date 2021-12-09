require_relative "spec_helper"

class Display
  attr_reader :lines, :out

  def initialize(lines)
    @lines = lines.map { |line| line.scan(/[a-g]+/) }
    @out = lines.map { _1[-4..] }
  end

  def easy_digit_count
    # digit => segment used
    # 1     => 2
    # 4     => 4
    # 7     => 3
    # 8     => 7
    out.flatten.count { |digit| [2, 4, 3, 7].include?(digit.length) }
  end

  # *acedgfb* cdfbe gcdfa fbcad *dab* cefabd cdfgeb *eafb* cagedb *ab* | cdfeb fcadb cdfeb cdbaf
  # 2 => ab
  # 4 => eafb
  # 7 => dab
  # 8 => acedgfb

  #   0:      1:      2:      3:      4:
  #  aaaa    ....    aaaa    aaaa    ....
  # b    c  .    c  .    c  .    c  b    c
  # b    c  .    c  .    c  .    c  b    c
  #  ....    ....    dddd    dddd    dddd
  # e    f  .    f  e    .  .    f  .    f
  # e    f  .    f  e    .  .    f  .    f
  #  gggg    ....    gggg    gggg    ....

  #   5:      6:      7:      8:      9:
  #  aaaa    aaaa    aaaa    aaaa    aaaa
  # b    .  b    .  .    c  b    c  b    c
  # b    .  b    .  .    c  b    c  b    c
  #  dddd    dddd    ....    dddd    dddd
  # .    f  e    f  .    f  e    f  .    f
  # .    f  e    f  .    f  e    f  .    f
  #  gggg    gggg    ....    gggg    gggg

  # using 2
  # a => c f
  # b => c f
  # using 4
  # e => b c d f
  # a => b c d f
  # f => b c d f
  # b => b c d f
  # using 7
  # d => a c f
  # a => a c f
  # b => a c f
  # using 8
  # a => a b c d e f g
  # b => a b c d e f g
  # c => a b c d e f g
  # d => a b c d e f g
  # e => a b c d e f g
  # f => a b c d e f g
  # g => a b c d e f g

  # a => *c* *f* + b *c* d *f* + a *c* *f* + a b *c* d e *f* g => c f
  # b => *c* *f* + b *c* d *f* + a *c* *f* + a b *c* d e *f* g => c f
  # c => *
  # d => a c f + a b c d e f g => a c f
  # e => b c d f
  # f => b c d f
  # g => *

  # Valid combinations
  # abcefg
  # cf
  # acdeg
  # acdfg
  # bcdf
  # abdfg
  # abdefg
  # acf
  # abcdefg
  # abcdfg

  # Normal
  #   aaaa
  #  b    c
  #  b    c
  #   dddd
  #  e    f
  #  e    f
  #   gggg

  # Input
  #  dddd
  # e    a
  # e    a
  #  ffff
  # g    b
  # g    b
  #  cccc

  # utiliser partie 1

  def output_sum
    lines.map do |digits|
      digits.map do |digit|
        value = if digit.length == 2
          "1"
        elsif digit.length == 4
          "4"
        elsif digit.length == 3
          "7"
        elsif digit.length == 7
          "8"
        else
          "."
        end

        puts [digit, value].inspect
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

    specify "output_sum", :focus do
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
    expect(Display.new(input).output_sum).to eql 61229
  end

  skip "part 2 - answer" do
  end
end
