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
    current_index = -1 # updates on each iteration to the next preceding index position until it finishes looping through index 0
    preceding_index = current_index - 1

    # iterate through price_per_day starting at index -1
    # for every current_index, loop through preceding index numbers somehow. Nested loops?
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

I took this to pen and paper as well, to avoid messing with code and to think like a programmer. In my scribbles, I more or less worked out that I might be able to swing this by comparing key/value pairs in hashes until I get the result I want.

Here's what I worked out on paper:

**objects for reference:**
`days` = [17,3,6,9,15,8,6,1,10]
`reversed_days` = [10,1,6,8,15,9,6,3,17] #easier than iterating in reverse, which I couldn't figure out before
`differences` = {i: [v, j]} # will use index position of buy dates as keys, sell value and sell day as values
`biggest_differences` = {i: [v, j]} # `differences`, except only the most profitable sell vales and dates will remain per purchase day key
`buy_sell_r` = [i: j] # 'r' is for reversed. The biggest difference in buy/sell dates from `biggest_differences` will be saved here
`buy_sell` = [i, j] # the correct index positions in the original array before it was reversed

**procedure**

1. create `differences` and `biggest_differences` hashes needed for comparing the difference of future calculations
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

1. loop through nested array of `differences`/`i` pairs in each key in the hash
2. in each value, search nested arrays for the largest value at their respective index `0`'s. (Can `#find_max` or something work here? This step is a bit of a magic box.)
3. save the largest difference value for each key into a new hash `biggest_differences` where the keys are the same as `differences`, and the values are only one array of the nested arrays containing the biggest difference and the index. (e.g. `0: [9, 1]`, `1: [-2, 7]` etc...)
4. loop through `biggest_differences` to find the biggest difference at each pair's index 0 (possibly using `#find_max` or similar), and save it to `buy_sell_r` as [`i`, `j`]
5. in `buy_sell_reversed`, find the equivilant values in `days` and save those index positions in a new array called `buy_sell`
6. return `buy_sell`

There. It's messy, inelegant, it might not work, but I got all the way through. It's like art: Make it badly, then make it pretty. That's what thumbnails and under-sketches are for.

Okay. Now I'm going to make and eat dinner, and when I come back, I'll look this over with fresh eyes and see if this holds water. Once I'm done tweaking this, I'll start thinking about how to solve my black box problems, as well as experiment in `scratch.rb` to make sure I can remember how to Ruby and see if loops, arrays, and hashes work as I expect/remember them to.

**Problem: Iterate over each hash key's values to find the nested array with the highest value at index 0**
This will find the best sale day for each key in the hash. Again, the key represents each buy date from the reversed array.

goal:

1. iterate through each key's value of array of nested arrays
2. identify the nested array with the highest sale value / difference at index 0
3. add that day to the `biggest_differences` hash

This took me a while to figure out. For some reason, I have much more trouble looking up solutions like this with Ruby than I did with JS, perhaps due to JS's ubiquity.

Reading: [Iterate through a hash in Ruby](https://koenwoortman.com/ruby-iterate-through-hash/) | [Mastering Nested Loops With Arrays](https://codesignal.com/learn/courses/mastering-implementation-of-advanced-loops-in-ruby/lessons/mastering-nested-loops-with-arrays)

For reference, the output for the `differences` hash looks like this when built:

```ruby
{
 0 => [[9, 1], [4, 2], [2, 3], [-5, 4], [1, 5], [4, 6], [7, 7], [-7, 8]],
 1 => [[0, 1], [-5, 2], [-7, 3], [-14, 4], [-8, 5], [-5, 6], [-2, 7], [-16, 8]],
 2 => [[5, 1], [0, 2], [-2, 3], [-9, 4], [-3, 5], [0, 6], [3, 7], [-11, 8]],
 3 => [[7, 1], [2, 2], [0, 3], [-7, 4], [-1, 5], [2, 6], [5, 7], [-9, 8]],
 4 => [[14, 1], [9, 2], [7, 3], [0, 4], [6, 5], [9, 6], [12, 7], [-2, 8]],
 5 => [[8, 1], [3, 2], [1, 3], [-6, 4], [0, 5], [3, 6], [6, 7], [-8, 8]],
 6 => [[5, 1], [0, 2], [-2, 3], [-9, 4], [-3, 5], [0, 6], [3, 7], [-11, 8]],
 7 => [[2, 1], [-3, 2], [-5, 3], [-12, 4], [-6, 5], [-3, 6], [0, 7], [-14, 8]],
 8 => [[16, 1], [11, 2], [9, 3], [2, 4], [8, 5], [11, 6], [14, 7], [0, 8]]
 }
```

After experimenting with my code in scratch.rb, the below code returns my desired output:

```ruby
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
```

output:

```ruby
"day 0 highest sale value and day: [9, 1]"
"day 1 highest sale value and day: [0, 1]"
"day 2 highest sale value and day: [5, 1]"
"day 3 highest sale value and day: [7, 1]"
"day 4 highest sale value and day: [14, 1]"
"day 5 highest sale value and day: [8, 1]"
"day 6 highest sale value and day: [5, 1]"
"day 7 highest sale value and day: [2, 1]"
"day 8 highest sale value and day: [16, 1]"
"biggest_differences hash: {0 => [9, 1], 1 => [0, 1], 2 => [5, 1], 3 => [7, 1], 4 => [14, 1], 5 => [8, 1], 6 => [5, 1], 7 => [2, 1], 8 => [16, 1]}"
```

**Problem: Find the biggest difference value from the biggest_differences hash**
Now all I have to do is find the best buy/sell dates by identifying the biggest value at index 0 across all the keys.

goal:

1. Iterate through `biggest_differences` hash
2. identify best sale date (must be key 8, value 16, 1)
3. push best sale date data to `buy_sell_r`

I expect this shouldn't be too dissimilar to what I did with the `differences` hash.

For reference, the biggest_differences hash is:

```ruby
{
  0 => [9, 1], 1 => [0, 1], 2 => [5, 1], 3 => [7, 1], 4 => [14, 1], 5 => [8, 1], 6 => [5, 1], 7 => [2, 1], 8 => [16, 1]
  }
```

So now all I have to do is save whichever key/value pair has the largest value at index 0.

Reference: [StackOverflow: find key by value](https://stackoverflow.com/questions/3794039/how-to-find-a-hash-key-containing-a-matching-value)

Ok so I managed to figure out that I can use `#values#max` with `biggest_differences` to arrive at `[16, 1]`.

I also found out I can find the key by the value, so I saved it to biggest_value and used `hash#key(biggest_value)`. No problem!

Now I have the biggest value and the associated key.

I pushed them to the array I made in advance using `buy_sell_r = [key_for_biggest_V, biggest_value]`

But I realized that I don't need the biggest difference value in the final product, so I should only push the value at index 1.

all put together:

```ruby
  biggest_value = biggest_differences.values.max
  pp "biggest_value: #{biggest_value}"
  # "biggest_value: [16, 1]"


  sell_day = biggest_value.drop(1)

  key_for_biggest_V = biggest_differences.key(biggest_value)
  pp "key for value: #{key_for_biggest_V}"
  # "key for value: 8"

  buy_sell_r = [key_for_biggest_V, sell_day]
  pp buy_sell_r.flatten
  # [8, 1]
```

## Struggle list / lessons learned

- misplaced ambition: trying to build a highly-optimized solution from the start, as if you can just go from concept to fully-rendered art piece without doing the important work of creating thumbnails and an underdrawing before finding all the problems and fixing them. Somehow I was better at this with JS than with Ruby, but JS is more familiar. I also need to let go of needing a highly-polished piece during learning. This isn't a portfolio piece.
- Rusty!! Ruby concepts are very rusty after a one-month break. Looking up how to do even the most basic of things, like the syntax for common, basic Ruby methods, knowing what methods are available for different purposes/outcomes, etc. I'm crawling. But progress is progress, even with one step back.
- how to iterate backwards through an array. On top of that, everything around that involved thinking in reverse, so I kept getting confused. Decided to reverse the array instead.
- determining how to iterate through an array twice, mainly not knowing which method to use, which was `#each_with_index`. I got really sidetracked with `#cons` and similar methods.
- basics rusty as well. Figuring out how to add a value to an existing key in a hash when the value is an array.
- [:i] wasn't working to add keys to the hash, because you can't add the index value as a symbol that way, so I added them with a plain [i]
- learned about guard clauses thanks to Rubocop
- trouble iterating over a hash to find the largest key. Have to iterate through the keys, then within each hash key, iterate over each value's array of nested arrays. I struggled to conceptualize nested loops even though I know I've handled them before in JS. Haven't I? Or did I just read about it?
  -- resource: [iterate through values](https://nelson.cloud/iterating-through-hashes-in-ruby/#iterating-through-values)
- Returning the entire nested array with the biggest value at index 0 - use `#max_by`. I was simply getting only the index 0s before I realized that `#max_by` can grab the whole thing based on an arguemnt. e.g. `value.max_by do { |arrays| array[0] }` will compare each nested array by their index 0s. _Huzzah!_
-
