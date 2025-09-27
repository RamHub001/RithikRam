class StringCalculatorService
  def add(numbers)
    return 0 if numbers.empty?

    delimiter = /,|\n/
    if numbers.start_with?("//")
      header, numbers = numbers.split("\n", 2)
      delimiter = Regexp.new(Regexp.escape(header[2..]))
    end

    nums = numbers.split(delimiter).map(&:to_i)
    negatives = nums.select { |n| n < 0 }
    raise "negative numbers not allowed #{negatives.join(',')}" if negatives.any?

    nums.sum
  end
end