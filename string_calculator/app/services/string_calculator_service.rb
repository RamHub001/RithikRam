class StringCalculatorService
  def add(numbers)
    return 0 if numbers.empty?

    delimiter = /,|\n/
    if numbers.start_with?("//")
      header, numbers = numbers.split("\n", 2)
      delimiter = Regexp.new(Regexp.escape(header[2..]))
    end

    numbers.split(delimiter).map(&:to_i).sum
  end
end