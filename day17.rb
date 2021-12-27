require_relative "spec_helper"

class ProbeLauncher
  class Trajectory
    attr_reader :current_x, :current_y, :x_velocity, :y_velocity

    def initialize(x_velocity, y_velocity)
      @x_velocity, @y_velocity = x_velocity, y_velocity
      @current_x = @current_y = 0
    end

    def step
      @current_x += x_velocity
      @current_y -= y_velocity
      if x_velocity > 0
        @x_velocity -= 1
      elsif x_velocity < 0
        @x_velocity += 1
      end
      @y_velocity -= 1
    end
  end

  def initialize(min_x, max_x, max_y, min_y)
    @min_x, @max_x, @min_y, @max_y = min_x, max_x, min_y * -1, max_y * -1
  end

  def reaches_target?(x_velocity, y_velocity)
    !max_y_for(x_velocity, y_velocity).nil?
  end

  def max_y_for(x_velocity, y_velocity)
    trajectory = Trajectory.new(x_velocity, y_velocity)
    count = 0
    min_reached_y = 0
    loop do
      count += 1
      trajectory.step
      min_reached_y = trajectory.current_y if trajectory.current_y < min_reached_y
      if trajectory.current_x >= min_x && trajectory.current_x <= max_x &&
        trajectory.current_y >= min_y && trajectory.current_y <= max_y
        return min_reached_y
      elsif trajectory.current_y > max_y
        return
      end
    end
  end

  def min_y_reaching_target
    min_reached_y = -1
    (1..max_x).to_a.each do |x_vel|
      (1..max_y).to_a.each do |y_vel|
        local_min_reached_y = max_y_for(x_vel, y_vel)
        next unless local_min_reached_y
        if local_min_reached_y < min_reached_y
          min_reached_y = local_min_reached_y
        end
      end
    end
    min_reached_y * -1
  end

  private

  attr_reader :min_x, :max_x, :min_y, :max_y
end

RSpec.describe "Day 17" do
  let(:example) do
    parse(
      <<~INPUT
        target area: x=20..30, y=-10..-5
      INPUT
    )
  end
  let(:input) { parse(File.read("day17_input.txt")) }

  def parse(input)
    input.split("\n").first.scan(/-?\d+/).map(&:to_i)
  end

  describe "scafolding" do
    specify "trajectory" do
      pt = ProbeLauncher::Trajectory.new(7, 2)
      pt.step
      expect(pt.current_x).to eql 7
      expect(pt.current_y).to eql -2
      pt.step
      expect(pt.current_x).to eql 13
      expect(pt.current_y).to eql -3
    end

    specify "reaches target #1" do
      p = ProbeLauncher.new(*example)
      expect(p.reaches_target?(7, 2)).to be true
    end

    specify "reaches target #2" do
      p = ProbeLauncher.new(*example)
      expect(p.reaches_target?(6, 3)).to be true
    end

    specify "reaches target #3" do
      p = ProbeLauncher.new(*example)
      expect(p.reaches_target?(9, 0)).to be true
    end

    specify "reaches target #4" do
      p = ProbeLauncher.new(*example)
      expect(p.reaches_target?(17, -4)).to be false
    end

    specify "reaches target #5" do
      p = ProbeLauncher.new(*example)
      expect(p.reaches_target?(6, 9)).to be true
    end
  end

  specify "part 1 - example" do
    p = ProbeLauncher.new(*example)
    expect(p.min_y_reaching_target).to eql 45
  end

  specify "part 1 - answer" do
    p = ProbeLauncher.new(*input)
    expect(p.min_y_reaching_target).to eql 5995
  end

  skip "part 2 - example" do
  end

  skip "part 2 - answer" do
  end
end
