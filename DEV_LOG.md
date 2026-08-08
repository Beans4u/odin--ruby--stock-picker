# DEV LOG: Stock Picker

## Task:

Implement a method #stock_picker that takes in an array of stock prices, one for each hypothetical day. It should return a pair of days representing the best day to buy and the best day to sell. Days start at 0.

```ruby
  > stock_picker([17,3,6,9,15,8,6,1,10])
  => [1,4]  # for a profit of $15 - $3 == $12
Quick Tips:
```

**Quick tips:**

- You need to buy before you can sell
- Pay attention to edge cases like when the lowest day is the last day or the highest day is the first day.

## Logic

Just thinking this through:

- Sell price should be higher than buy price
- Gains should be significant
- Only need to return the buy and sell indexes

### Idea 1: Iterate backwards, replace highest calculated difference in stored value which gets returned

What if I iterate through the `stock_picker` array and compare each "day" (index) with the rest using something like `#reduce`, then return the biggest difference to the caller. The caller can then return the best day to buy and sell for that index.

The biggest ROI will then be returned as the "days" (indexes) offered.

Is there a simpler way to do this?

I sketched it out on paper, and came away with:

- iterate from last index to first and calculate difference from last index to previous indexes
- record first result [8, 7, 9] (index 8, index 7, difference 9)
- overwrite result if another set of indexes have a difference higher than the last recorded difference, e.g. [1, 4, 13]
- when loop is complete, repeat with the next last index (7 - 6, then 7 - 4, etc.)

something like:

```ruby
price_per_day = [[17,3,6,9,15,8,6,1,10]]
def stock_picker(price_per_day)
    biggest_difference = [0, 0, 0]
    current_difference = [0, 0, 0]
    current_index = -1 # updates on each iteration to the next preceedign index position until it finishes looping through index 0
    preceeding_index = current_index - 1

    # iterate through price_per_day starting at index -1
    # for every current_index, loop through preceeding index numbers somehow. Nested loops?
    # subtract value of index -1 with preceding values in decreasing order, e.g. 10 - 1, 10 - 2, ...
    # record the operation parameters at -1, e.g. biggest_difference = [8, 7, 9]
    # if the value of the difference with the next calculations are larger than the recorded difference, overwrite the biggest_difference with the new indexes and difference, e.g. if current_difference[2] > biggest_difference[2] biggest_difference = current_difference
    # once all the calculations are complete for the -1 starting point, repeat the loop from the next one down somehow - -1 + -1? I don't know how to handle that.
    # when all the loops are complete, print biggest_difference[0, 1]
end
```

Challenge: how do I loop starting from a specific index with the index decreasing each time?

#### Execution??

I can imagine using a reduce method, using current_difference and biggest_difference as the result and next value, if it can somehow work with multiple values.

There is a [#reverse_each](https://docs.ruby-lang.org/en/3.4/Array.html#method-i-reverse_each) method I could try

How can I target the index before the one being iterated on? something like `current_index -1`?

Instead of doing multiple calculations, could I use `minmax` or similar to find the minimum number preceeding the one being iterated on, then calculate the difference?

e.g. `current_index = -1`, `minmax` block from `index` `0` to `current_index` produces `1`, calculate difference to find `9`, record in current_difference (because the default is 0, 0, 0). If the min number preceedign `current_index` is larger than `current_index`, we skip calculation.

so:

```ruby
price_per_day = [[17,3,6,9,15,8,6,1,10]]
def stock_picker(price_per_day)
    biggest_difference = [0, 0, 0]
    current_difference = [0, 0, 0]
    current_index = -1 # updates on each iteration to the next preceeding index position until it finishes looping through index 0
    preceeding_index = current_index - 1

    # iterate through price_per_day starting at index -1
    # for every current_index, loop through preceeding index numbers somehow. Nested loops?
    # subtract value of index -1 with preceding values in decreasing order, e.g. 10 - 1, 10 - 2, ...
    # record the operation parameters at current_index, e.g. current_difference = [8, 7, 9]
    # if the value of the difference with the next calculations in current_difference are larger than the recorded difference, overwrite the biggest_difference with the new indexes and difference, e.g. if current_difference[2] > biggest_difference[2] biggest_difference = current_difference => 1, 4, 13
    # once all the calculations are complete for the -1 starting point, update current_index to current_index - 1, then repeat the loop with that as the starting index somehow. I don't know how to handle that.
    # when all the loops are complete, return biggest_difference[0, 1]
end
```

#### Focus on just the loop

Ok looks good on paper, but I only have a vague idea of how to execute this. I'm going to "think like a programmer" and boil it down to the most simple version of the problem. What exactly would that be?

A simplified version might be [iterating backwards](https://w3ird.tech/posts/iterating-backwards-ruby-array/) and finding the minimum number per current_index without worrying about output or calculations. It is the piece I'm most confused about. I'll work on that first.

so:

I'm not sure how to isolate the last array index as a variable except by using -1. But, when I subtract from that, will it work properly?

I'm not even sure I need to record those, I could be over-engineering because I got ahead of experimenting in the irb. Guess I'll find out!

It is now occurring to me that I don't actually need to iterate backwards if I can just find the min within the range 0 - current_index. This might simplify things.

```ruby
price_per_day = [17,3,6,9,15,8,6,1,10]
def stock_picker(price_per_day)
    current_index = # somehow store the current index? ## updates on each iteration to the next preceeding index position until it finishes looping through index 0
    preceeding_index = current_index - 1

    # behaviour:
        # a method that iterates through price_per_day backwards
        # store value of current_index
        # preceeding_index = current_index -= 1
        # loop continues from current_index
        # When the current_index value reaches 0, terminate execution
end
```

### Idea: What I use a Hash?

I might be overcomplicating this just to save so-called "computational overhead" for something that doesn't have a lot of mass. Would it just be easier to put this into a hash? Every calculation can occur after all, and I add each pair to the hash along with their calculated result.

e.g.

```ruby
price_per_day = [17,3,6,9,15,8,6,1,10]
profit_data = Hash.new

def stock_picker(closing_prices)
    closing_prices.each_slice(2).with_index do |(buy_date, sell_date), i|
    puts "#{i}, #{sell_date} - #{buy_date}"
    p sell_date - buy_date
    end

end
```

```python
price_days = [50, 12, 40, 5, 90, 130, 30, 2]
profit_map: hash = {}

for sell_value, sell_index in each_with_index(price_days)
  preceding_days = price_days[0..sell_index]
  for buy_value, buy_index in each_with_index(preceding_days)
    profit_map["{buy_index},{sell_index}"] = sell_value - buy_value
```

## idea #2: Lots of storage hashes

I took well over a month off TOP, and during that time, I realized that I was trying way too hard since the start of my entire TOP career to create the most elegant and professional code possible, which really slows me down and is not condusive to learning. So, I am going to drop that perfectionism as much as I am able, and code to learn and not code for hypothetical code reviews to be pushed.

I took this to pen and paper as well, to get out of messing with code and to think like a programmer. In my scribbles I more or less worked out that I might be able to swing this by comparing key value pairs in hashes until I get the result I want.

Here's what I worked out on paper:

`days` = [17,3,6,9,15,8,6,1,10]
`reversed_days` = [10,1,6,8,15,9,6,3,17]

1. create hashes needed for comparing the difference of future calculations
2. reverse the `days` array => `reversed_days = days.reverse`
3. LOOP1: loop through `reversed_days` for index `i` (e.g. in the first loop, `i` will be `0`, whose value is `10`)
4. LOOP2: in the LOOP1, loop through `reversed_days` again for index `j`, and skip index `0` with an if statement (e.g. in the first loop, `j` will be `1`, whose value is `1`)
5. LOOP2: `difference` = `i` - `j`
6. LOOP2: add the three variables to the `differences` hash where `i` is the key and `difference` and `j` are the pair as an array. If the key doesn't exist yet, create an empty array as the pair, then add `difference` and `j` to it as a sub-array. If the hash key already exists, then add the pair as a sub array item after the last-entered one.
7. LOOP2: will exhaust all 8 days and return to LOOP1
8. LOOP1: will now step through loop with `i` in position `1`
9. LOOP2: will repeat the previous LOOP2 steps

Then once I have a full hash of keys `0` through `8`, and pairs of differences in subarrays:

`differences` might look like this:

```ruby
`differences` = {`i` : [`difference.to_i`, `j`]} #from LOOP2

differences =
{
    0: [ [9,1], [4,2], [2,3] ] #etc...
    1: [ [-5,2], [-7,3] [-14,4] ] #etc...
    #...
}
```

Once that is built with all 9 days, indexes, and differences:

1. loop through `differences` pairs for each key
2. in each pair, search subarrays for the largest value at their respective index `0`'s.
3. can find_max or something work here? This step is a bit of a magic box
4. save the largest difference value for each key into a new hash `biggest_differences` where the keys are the same as `differences`, and the values are only one top-level array of the array with the biggest difference and the index. (e.g. `0: [9, 1]`, `1: [-2, 7]` etc...)
5. loop through `biggest_differences` to find the biggest difference at each pair's index 0 (possibly using find_max or similar), and save it to `buy_sell_r` as [`i`, `j`]
6. in `buy_sell_reversed`, find the equivilant values in `days` and save those index positions in a new array called `buy_sell`
7. return `buy_sell`

There. It's messy, inelegant, it might not work, but I got all the way through. It's like art: Make it badly, then make it pretty. That's what thumbnails and under-sketches are for.

Okay. Now I'm going to make and eat dinner, and when I come back, I'll look this over with fresh eyes and see if this holds water. Once I'm done tweaking this, I'll start thinking about how to solve my black box problems, as well as experiment in `scratch.rb` to make sure I can remember how to Ruby and see if loops, arrays, and hashes work as I expect/remember them to.
