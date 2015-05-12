# ConvenientGrouper

This gem simplifies grouping records. The primary intention is to make group-aggregation-methods easier.

To use, add the following to your Gemfile.

[![Build Status](https://travis-ci.org/humzashah/convenient_grouper.svg?branch=master)](https://travis-ci.org/humzashah/convenient_grouper)

```ruby
gem 'convenient_grouper'
```

After `bundle install`, you can provide the grouping details as a hash with the column as the hash's key.

### Usage:

```ruby
ModelName.group(grouping_hash, options)
```

First argument to method is a grouping hash:

```ruby
grouping_hash = {
  column_name: {
    group_name_one: a_range_or_array, # group if column value within range/array
    group_name_two: a_specific_value, # group if column value equals

    # comparison operators: !=, <, <=, >, >=
    # work best for values whose to_s does not yield spaces
    group_name_four: "!= #{some_value_one}",
    group_name_five: "> #{some_value_two}",
    group_name_six: "<= #{some_value_three}",

    # default group
    nil => some_string # default value is 'others'
  }
}
```

Second argument is an optional hash:

```ruby
# restrict query to grouped conditions. defaults to false.
options = { restrict: boolean }
```

If you pass only one non-hash argument, you will be using `ActiveRecord`'s own `group` method.

### Example 1

Getting profits for different dates and date-ranges from a `Sale` model:

```ruby
Sale.group({
  date_of_sale: {
    Jan: Date.new(2015, 1)..Date.new(2015, 1, 31),
    date: Date.new(2014, 4, 5),
    dates: [Date.new(2014, 1, 2), Date.new(2014, 2, 1)],
    unspecified: nil
  }
}).sum(:profit)
#=> {"Jan" => 1550, "date" => 50, "dates" => 100, "unspecified" => 25, "others" => 50000}
```

### Example 2

Counting employees in various age-groups:

```ruby
Employee.group({
  age: {
    young_adults: 18..25,
    adults: 25..35,
    seniors: ">= 60",
    nil => 'mature_adults'
  }
}).count
#=> {"young_adults" => 13, "adults" => 15, "seniors" => 4, "mature_adults" => 5}
```

### Example 3

Grouping events that are occurring after a particular date:

```ruby
date = Date.new(2015, 6, 22)
Event.group(date: {
  not_on_date: ">= #{date}"
})
```

### Example 4

Restricting your query to the conditions specified in your `group` clause:

```ruby
range = 13..19
Relative.group({
  age: {teens: range}
}, restrict: true) # == Employee.where(age: range).group(hash)
```

### Heads-Up

A heads-up for specifying the extra options such as `restrict`:

Ruby will interpret the following as a single hash-argument:

```ruby
Relative.group(age: {teens: 13..19}, restrict: true) # wrong
```

Therefore you will need appropriate curly braces:

```ruby
Relative.group({age: {teens: 13..19}}, {restrict: true}) # right
```

### Bug Reports

Things seemingly work well for the most usual use-cases. Nonetheless, bug-reports are welcomed.
