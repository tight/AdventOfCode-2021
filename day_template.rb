require_relative "spec_helper"

public

RSpec.describe "Day XXX" do
  let(:example) do
    parse(
      <<~INPUT
      INPUT
    )
  end
  let(:input) { parse(File.read("dayXXX_input.txt")) }

  def parse(input)
    input.split("\n")
  end

  specify "part 1 - example" do
  end

  skip "part 1 - answer" do
  end

  skip "part 2 - example" do
  end

  skip "part 2 - answer" do
  end
end
