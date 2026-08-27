# frozen_string_literal: true

days = [17, 3, 6, 9, 15, 8, 6, 1, 10]

def find_days(buy_sell_days)
  reversed_days = buy_sell_days.reverse
  differences = {}
  biggest_differences = {}
  buy_sell_r = []
  buy_sell = []

  # + + + + + REVERSED DAYS ARRAY LOOP + + + + + +

  reversed_days.each_with_index do |price_i, i|
    differences[i] = [] unless i == reversed_days.length - 1
    next if i == (reversed_days.length - 1) # prevent calculating last index with nothing

    reversed_days.each_with_index do |price_j, j|
      next if j <= i # prevent comparing day 1 to day 1

      difference = (price_i - price_j)

      differences[i] << [difference, j] if i != (reversed_days.length - 1)
    end
  end

  # + + + + + DIFFERENCES HASH LOOP + + + + + +

  differences.each do |key, value|
    highest_day = value.max_by do |arrays| 
      arrays[0]
    end

    biggest_differences[key] = highest_day
  end

  biggest_value = biggest_differences.values.max

  sell_day = biggest_value.drop(1)

  key_for_biggest_v = biggest_differences.key(biggest_value)

  buy_sell_r = [key_for_biggest_v, sell_day]

  buy_sell_r_f = buy_sell_r.flatten

  # + + + RETURN BUY/SELL DAYS INDEXES TO ORIGINAL ORDER + + + +

  total_days = (reversed_days.length - 1)

  buy_sell_r_f.each do |n|
    shifted_day = (total_days - n)

    buy_sell << shifted_day
  end

  buy_sell
end # find_days method end

stock_advice = find_days(days)

pp stock_advice