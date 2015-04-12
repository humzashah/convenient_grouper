# ConvenientGrouper

This gem simplifies grouping records. The primary intention is to make group-aggregation-methods easier.

To use, add the following to your Gemfile.

    gem 'convenient_grouper'

After `bundle install`, you can provide the grouping details as a hash with the column as the hash's key.

### Usage:

First argument to method is a grouping hash:

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

Second argument is optional. So far, the options include:

    options = {
      restrict: boolean # restrict query to grouped conditions. defaults to false.
    }

Method call:

    ModelName.group(grouping_hash, options)

If you pass only one non-hash argument, you'll be using `ActiveRecord`'s own `group` method.

### Example 1

    Sale.group({
      date_of_sale: {
        Jan: Date.new(2015, 1)..Date.new(2015, 1, 31),
        date: Date.new(2014, 4, 5),
        dates: [Date.new(2014, 1, 2), Date.new(2014, 2, 1)],
        unspecified: nil
      }
    }).sum(:profit)
    #=> {"Jan" => 1550, "date" => 50, "dates" => 100, "unspecified" => 25, "others" => 50000}

### Example 2

    Employee.group({
      age: {
        young_adults: 18..25,
        adults: 25..35,
        seniors: ">= 60",
        nil => 'mature_adults'
      }
    }).count
    #=> {"young_adults" => 13, "adults" => 15, "seniors" => 4, "mature_adults" => 5}

### Example 3

    date = Date.new(2015, 6, 22)
    Event.group(date: {
      not_on_date: ">= #{date}"
    })

### Example 4

    range = 13..19
    Relative.group({
      age: {teens: range}
    }, restrict: true) # == Employee.where(age: range).group(hash)

Things seemingly work well for the most usual use-cases. Nonetheless, bug-reports are welcomed.
