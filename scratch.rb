# frozen_string_literal: true

days = [17, 3, 6, 9, 15, 8, 6, 1, 10]

def find_days(buy_sell_days)
  reversed_days = buy_sell_days.reverse
  differences = {} # save the difference between the next sell date with the current sale date
  biggest_differences = {}
  buy_sell_r = []
  buy_sell = []

  # + + + + + REVERSED DAYS ARRAY LOOP + + + + + +

  reversed_days.each_with_index do |price_i, i|
    differences[i] = [] unless i == reversed_days.length - 1
    next if i == (reversed_days.length - 1) # prevent calculating last index with nothing

    reversed_days.each_with_index do |price_j, j|
      next if j <= i # prevent comparing day 1 to day 1

      # pp "day #{i}: closed at $#{price_i} and day #{j}: closed at $#{price_j}"

      difference = (price_i - price_j)
      #  pp "#{price_i} - #{price_j} = #{difference}"
      #  pp "day #{i} and day #{j} difference: $#{difference}"
      differences[i] << [difference, j] if i != (reversed_days.length - 1)
      # pp differences
      # differences[:i] += [difference, j]
      # differences.except([])
      # pp "added #{difference} and j index #{j} to differences"
    end # end of reversed_days.each_with_index do |price_j, j|

      # pp "differences updated at end of both loop j: #{differences}"
  end # end of reversed_days.each_with_index do |price_i, i|

  # pp "differences updated at end of both loops: #{differences}"

  # + + + + + DIFFERENCES HASH LOOP + + + + + +
  # pp differences
  differences.each do |key, value|
      # pp "values for key: #{key} and values: #{value}"
      # pp "key: #{key} and value: #{value[0][0]}"
    highest_day = value.max_by do |arrays| # find highest value at index 0 to find the best sell day
      arrays[0]
    end
    # pp "day #{key} highest sale value and day: #{highest_day}"
    biggest_differences[key] = highest_day
  end

  # pp "biggest_differences hash: #{biggest_differences}"

  biggest_value = biggest_differences.values.max
  # pp "biggest_value: #{biggest_value}"

  sell_day = biggest_value.drop(1)

  key_for_biggest_v = biggest_differences.key(biggest_value)
  # pp "key for value: #{key_for_biggest_V}"
  # pp "key_for_biggest_v type is Integer?: #{key_for_biggest_v.is_a?(Integer)}"
  # pp "biggest_differences type is Array?: #{sell_day.is_a?(Array)}"
  buy_sell_r = [key_for_biggest_v, sell_day]
  buy_sell_r_f = buy_sell_r.flatten
  # pp buy_sell_r.flatten
  # pp "buy sell r type is Array?: #{buy_sell_r.is_a?(Array)}"
  

  # + + + RETURN BUY/SELL DAYS INDEXES TO ORIGINAL ORDER + + + +
  pp "reversed days: #{reversed_days}"

  # buy_day_r = buy_sell_r[1] #reversed, so the buy day is after the sell day
  # sell_day_r = buy_sell_r[0]
  # pp "buy day value: #{buy_day_r} and sell day value: #{sell_day_r}"

  # pp reversed_days.find_index {|e| e == buy_day_r}

  # pp days.select{|i| i == buy_day_r}
 

  total_days = (reversed_days.length - 1)
  # pp "total days: #{total_days}"

  buy_sell_r_f.each do |n|
    # pp "this is buy_sell_r_f: #{buy_sell_r_f}"
    pp "this n is: #{n}"
    # pp "n type is Array?: #{n.is_a?(Array)}"
    shifted_day = (total_days - n)
    pp "shifted day: #{shifted_day}"

    buy_sell << shifted_day
    pp "this is buy_sell: #{buy_sell}"
  end

  pp buy_sell


end # find_days method end

find_days(days)

#### old
  # max_value = differences.max_by do |k, v|
  #   pp "max value: #{v}"
  # end

  # pp "max val: #{max_value}"

  # differences.each_key do |i|
  #   i.find_max
  # end

#### Pairs experiment, doesn't work because I can't add them to the hash the way I want to
#   pairs = []
#   reversed_days.combination(2) {|combo| pairs.push(combo)}
# p pairs

#### Arrays playground - multidimentional arrays refresher
# find_the_highest = [[1, 2], [2, 3], [6, 4], [8, -1]]

# # pp "find the highest: #{find_the_highest[3]}"

# numbers = [[10, 20], [30, 40], [50, 60]]

# numbers.each do |number|
#   number[1]
# end

# numbers.map do |number|
#   number[0]
# end

# highest = find_the_highest.map do |pair|
#   result = []
#   result << pair[0]
# end

# highest.max