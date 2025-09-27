require 'rails_helper'

RSpec.describe StringCalculatorService do
  subject(:calculator) { described_class.new }

  describe "#add" do
    it "returns 0 for an empty string" do
      expect(calculator.add("")).to eq 0
    end

    it "returns the number itself when input has one number" do
      expect(calculator.add("1")).to eq 1
    end

    it "returns the sum of two comma-separated numbers" do
      expect(calculator.add("1,5")).to eq 6
    end

    it "handles any amount of numbers" do
      expect(calculator.add("1,2,3,4,5")).to eq 15
    end

    it "handles new lines between numbers" do
      expect(calculator.add("1\n2,3")).to eq 6
    end

    it "supports custom delimiters" do
      expect(calculator.add("//;\n1;2")).to eq 3
    end
  end
end