# README

This [Stock Picker](https://www.theodinproject.com/lessons/ruby-stock-picker) assignment is part of the [Ruby on Rails](https://www.theodinproject.com/paths/full-stack-ruby-on-rails) curriculum from The Odin Project.

[The Odin Project](https://www.theodinproject.com/about) provides a high quality coding education maintained by an open source community.

## Assignment: Stock Picker

Implement method #`stock_picker` that receives an array of stock prices and returns a pair of "days" representing which days to buy and sell.

e.g.

```ruby
  > stock_picker([17,3,6,9,15,8,6,1,10])
  => [1,4]  # for a profit of $15 - $3 == $12
```

**Constraints:**  
Must buy before selling.

**See:**

- [stock_picker](./stock_picker.rb) for 'final' project (requires refactor)
- [DEV_LOG](./DEV_LOG.md) for my stream-of-consciousness thought process written in my own loose dialect (will hurt your brain)
- [scratch](./scratch.rb) playground, loose construction record (will hurt your eyes)
