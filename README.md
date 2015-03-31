# ConvenientGrouper

This gem simplifies grouping records. The primary intention is to make group-aggregation-methods easier.

To use, add the following to your Gemfile.

    gem 'convenient_grouper'

After `bundle install`, you can simply provide the grouping details as a hash with the column as the key:

### Example 1

    Sale.
    group(created_at: {
      february: Date.new(2015, 2)..Date.new(2015, 2, 28),
      january: Date.new(2015, 1)..Date.new(2015, 1, 31),
      others: nil, # optional default group. default value == 'others'
    }).
    sum(:proceeds)
    #=> {"february" => 271899, "january" => 565095, "others" => 15512466}

### Example 2

    Employee.
    group(age: {
      young_adults: 18..25,
      adults: 25..35,
      mature_adults: nil
    }).
    count
    #=> {"young_adults" => 13, "adults" => 15, "mature_adults" => 5}

Admittedly, I've written this gem in haste and not tested special cases. But for "everyday" usage, things seem to be working well. You can presently use the hash for single-column groups, much like in the examples I've shown above.

Adding support for multiple columns, auto-restricting records to ranges in hash, and auto-naming groups are all planned changes.

I welcome bug-reports, issue highlights, and useful contributions.

## Contributing

1. Fork the project
2. Create your feature branch
3. Write RSpec tests for your changes
4. Commit your changes
5. Push to the branch
6. Create a new 'Pull Request'
