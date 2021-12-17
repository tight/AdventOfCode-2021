require_relative "spec_helper"

class BITS
  HEX_TO_BITS = {
    "0" => "0000",
    "1" => "0001",
    "2" => "0010",
    "3" => "0011",
    "4" => "0100",
    "5" => "0101",
    "6" => "0110",
    "7" => "0111",
    "8" => "1000",
    "9" => "1001",
    "A" => "1010",
    "B" => "1011",
    "C" => "1100",
    "D" => "1101",
    "E" => "1110",
    "F" => "1111",
  }

  attr_reader :ip, :bits

  def initialize(hex)
    @bits = hex_to_bin(hex)
  end

  def parse
    debug "# parse"
    @ip = 0
    [parse_packet]
  end

  def versions
    compute_versions(parse)
  end

  def compute_versions(packets)
    if packets.is_a?(Array)
      packets.map do |packet|
        packet.first + compute_versions(packet[2])
      end.sum
    else
      0
    end
  end

  def parse_packet
    debug "# parse_packet"
    debug "--- packet at #{ip}"
    version = read(3, "version")
    type = read(3, "type")
    if type == 4
      debug "- literal value"
      parse_value(version, type)
    else
      debug "- operator"
      parse_operator(version, type)
    end

  end

  def parse_operator(version, type)
    debug "# parse_operator"
    type = read(1, "operator type")
    if type == 1
      debug "- operator type 1"
      sub_packet_count = read(11, "sub packet count")
      [version, type, sub_packet_count.times.map { parse_packet }]
    else # 0
      debug "- operator type 0"
      sub_packets_total_length = read(15, "sub packet total length")
      sub_packer_start_ip = ip
      sub_packets = []
      loop do
        debug "- reading sub packet (#{ip - sub_packer_start_ip} vs #{sub_packets_total_length})"
        sub_packets << parse_packet
        break if ip - sub_packer_start_ip == sub_packets_total_length
      end
      [version, type, sub_packets]
    end
  end

  def parse_value(version, type)
    debug "# parse_value"
    values = ""
    loop do
      debug "- loop if zero"
      stop_if_zero = read(1, "stop if zero")
      values << read_bits(4, "partial value")
      break if stop_if_zero == 0
    end
    debug "value in bits => #{values}"
    # while ip % 4 != 0
    #   debug "skip"
    #   @ip += 1
    # end
    value = bin_to_dec(values)
    debug "value in dec => #{value}"
    [version, type, value]
  end

  def read(n, what)
    bin_to_dec(read_bits(n, what)).tap do |v|
      debug "=> #{v}"
    end
  end

  def read_bits(n, what)
    bits[ip, n].tap do |v|
      debug "#{what} => #{v} (IP: #{ip})"
      @ip += n
    end
  end

  def hex_to_bin(hex)
    # hex.to_i(16).to_s(2) => ignores leading 0
    hex.gsub(/./, HEX_TO_BITS)
  end

  def bin_to_dec(bin)
    bin.to_i(2).to_s(10).to_i
  end

  def debug(str)
    # puts str
  end
end

RSpec.describe "Day 16" do
  let(:input) { parse(File.read("day16_input.txt")) }

  def parse(input)
    input.split("\n").first
  end

  describe "part 1 - examples" do
    specify "literal value" do
      expect(BITS.new("D2FE28").parse).to eql [[6, 4, 2021]]
    end

    specify "operator type 0" do
      expect(BITS.new("38006F45291200").parse).to eql [[1, 0, [[6, 4, 10], [2, 4, 20]]]]
    end

    specify "operator type 1" do
      expect(BITS.new("EE00D40C823060").parse).to eql [[7, 1, [[2, 4, 1], [4, 4, 2], [1, 4, 3]]]]
    end

    specify "versions test 1" do
      expect(BITS.new("8A004A801A8002F478").versions).to eql 16
    end

    specify "versions test 2" do
      expect(BITS.new("620080001611562C8802118E34").versions).to eql 12
    end

    specify "versions test 3" do
      expect(BITS.new("C0015000016115A2E0802F182340").versions).to eql 23
    end

    specify "versions test 4" do
      expect(BITS.new("A0016C880162017C3686B18A3D4780").versions).to eql 31
    end
  end

  specify "part 1 - answer" do
    expect(BITS.new(input).versions).to eql 860
  end

  skip "part 2 - example" do
  end

  skip "part 2 - answer" do
  end
end
