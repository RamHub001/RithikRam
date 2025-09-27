require 'rails_helper'

RSpec.describe StringCalculatorService do
  subject(:calculator) { described_class.new }

  describe "#add" do
    it "returns 0 for an empty string" do
      expect(calculator.add("")).to eq 0
    end
  end
end