# ConvenientGrouper

This gem simplifies grouping records. The primary intention is to make group-aggregation-methods easier.

To use, add the following to your Gemfile.

    gem 'convenient_grouper'

After `bundle install`, you can simply provide the grouping details as a hash with the column as the key:

### Example 1

    Sale.
    group(created_at: {
      # hash value could be nil, a particular value, a range, or an array
      february: Date.new(2015, 2)..Date.new(2015, 2, 28),
      january: Date.new(2015, 1)..Date.new(2015, 1, 31),
      nil => 'others' # optional default group. default value == 'others'
    }).
    sum(:proceeds)
    #=> {"february" => 271899, "january" => 565095, "others" => 15512466}

### Example 2

    Employee.
    group(age: {
      young_adults: 18..25,
      adults: 25..35,
      nil => 'mature_adults'
    }).
    count
    #=> {"young_adults" => 13, "adults" => 15, "mature_adults" => 5}

### Example 3

    grouping_hash = {
      age: {
        young_adults: 18..25
        adults: 25..35
      }
    }

    Employee.
    group(
      grouping_hash,
      restrict: true # restrict rows to your grouped conditions
    ).
    count

Admittedly, I've written this gem in haste and not tested special cases. But things seemingly work well for the most usual use-cases. Nonetheless, I welcome bug-reports. I'll be working on the code myself but your contribution can be in the form of bug-reports and/or ideas.
