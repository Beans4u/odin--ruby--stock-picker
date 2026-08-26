# frozen_string_literal: true

days = [17, 3, 6, 9, 15, 8, 6, 1, 10]

def find_days(buy_sell_days)
  reversed_days = buy_sell_days.reverse
  differences = {} # save the difference between the next sell date with the current sale date
  biggest_differences = {}
  # buy_sell_r = []
  # buy_sell = []

  # + + + + + REVERSED DAYS ARRAY LOOP + + + + + +
  
  reversed_days.each_with_index do |price_i, i|
    differences[i] = []
    reversed_days.each_with_index do |price_j, j|
      if j.zero?
        next # prevent comparing day 1 to day 1
      end
      # pp "day #{i}: price $#{price_i} and day #{j}: price $#{price_j} "

      difference = (price_i - price_j)
      # pp "day #{i} and day #{j} difference: $#{difference}"

      # differences[:i] += [difference, j]
      differences[i] << [difference, j]
      # pp "added #{difference} and #{j} to differences"
    end
      # pp "differences updated at end of both loop j: #{differences}"
  end
  # pp "differences updated at end of both loops: #{differences}"

  # + + + + + DIFFERENCES HASH LOOP + + + + + +
pp differences
  differences.each do |key, value|
      # pp "values for key: #{key} and values: #{value}"
      # pp "key: #{key} and value: #{value[0][0]}"
    highest_day = value.max_by do |arrays| # find the nested array with the highest value at index 0 to find the best sell day
      arrays[0]
    end
    pp "day #{key} highest sale value and day: #{highest_day}"
    biggest_differences[key] = highest_day
  end

  pp "biggest_differences hash: #{biggest_differences}"


end # find_days method end

#### old
  # max_value = differences.max_by do |k, v|
  #   pp "max value: #{v}"
  # end

  # pp "max val: #{max_value}"

  # differences.each_key do |i|
  #   i.find_max
  # end


find_days(days)

#### Pairs experiment, doesn't work because I can't add them to the hash the way I want to
#   pairs = []
#   reversed_days.combination(2) {|combo| pairs.push(combo)}
# p pairs

#### Arrays playground - multidimentional arrays refresher
find_the_highest = [[1, 2], [2, 3], [6, 4], [8, -1]]

# pp "find the highest: #{find_the_highest[3]}"

numbers = [[10, 20], [30, 40], [50, 60]]

numbers.each do |number|
  number[1]
end

numbers.map do |number|
  number[0]
end

highest = find_the_highest.map do |pair|
  result = []
  result << pair[0]
end

highest.max