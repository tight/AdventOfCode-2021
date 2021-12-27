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
    debug @bits.inspect
  end

  def parse
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

  def compute
    compute_packets(parse).first
  end

  def compute_packets(packets)
    packets.map do |packet|
      version, type, value_or_sub_packets = packet
      if type == 4
        value_or_sub_packets
      elsif type == 0 # sum
        compute_packets(value_or_sub_packets).inject(&:+)
      elsif type == 1 # product
        compute_packets(value_or_sub_packets).inject(&:*)
      elsif type == 2 # min
        compute_packets(value_or_sub_packets).min
      elsif type == 3 # max
        compute_packets(value_or_sub_packets).max
      elsif type == 5 # greater than
        a, b = compute_packets(value_or_sub_packets)
        a > b ? 1 : 0
      elsif type == 6 # less than
        a, b = compute_packets(value_or_sub_packets)
        a < b ? 1 : 0
      elsif type == 7 # equals
        a, b = compute_packets(value_or_sub_packets)
        a == b ? 1 : 0
      else
        raise "Packet type #{type.inspect} unknown"
      end
    end
  end

  def parse_packet
    debug "--- packet at #{ip}"
    version = read(3, "version")
    type = read(3, "type")
    if type == 4
      debug "- literal value"
      parse_value(version, type)
    else
      debug "- operator type #{type}"
      parse_operator(version, type)
    end
  end

  def parse_operator(version, type)
    mode = read(1, "operator mode")
    if mode == 1
      debug "- operator mode 1"
      sub_packet_count = read(11, "sub packet count")
      [version, type, sub_packet_count.times.map { parse_packet }]
    else # 0
      debug "- operator mode 0"
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

    specify "operator mode 0" do
      expect(BITS.new("38006F45291200").parse).to eql [[1, 6, [[6, 4, 10], [2, 4, 20]]]]
    end

    specify "operator mode 1" do
      expect(BITS.new("EE00D40C823060").parse).to eql [[7, 3, [[2, 4, 1], [4, 4, 2], [1, 4, 3]]]]
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

  describe "part 2 - examples" do
    specify "sum" do
      expect(BITS.new("C200B40A82").compute).to eql 3
    end

    specify "product" do
      expect(BITS.new("04005AC33890").compute).to eql 54
    end

    specify "min" do
      expect(BITS.new("880086C3E88112").compute).to eql 7
    end

    specify "max" do
      expect(BITS.new("CE00C43D881120").compute).to eql 9
    end

    specify "less than" do
      expect(BITS.new("D8005AC2A8F0").compute).to eql 1
    end

    specify "greater" do
      expect(BITS.new("F600BC2D8F").compute).to eql 0
    end

    specify "not equals" do
      expect(BITS.new("9C005AC2F8F0").compute).to eql 0
    end

    specify "equals 2" do
      expect(BITS.new("9C0141080250320F1802104A08").compute).to eql 1
    end
  end

  specify "part 2 - answer" do
    expect(BITS.new(input).compute).to eql 470949537659
  end
end
