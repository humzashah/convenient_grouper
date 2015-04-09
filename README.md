# ConvenientGrouper

This gem simplifies grouping records. The primary intention is to make group-aggregation-methods easier.

To use, add the following to your Gemfile.

    gem 'convenient_grouper'

After `bundle install`, you can simply provide the grouping details as a hash with the column as the key:

### Example 1

    Sale.group({
      date_of_sale: {
        Jan: Date.new(2015, 1)..Date.new(2015, 1, 31),
        date: Date.new(2014, 4, 5),
        dates: [Date.new(2014, 1, 2), Date.new(2014, 2, 1)],
        unspecified: nil,
        nil => 'others' # optional default group. default value == 'others'
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

    # restrict rows/query to your grouped conditions
    hash = {age: {adults: ">= 18"}}
    Employee.group(hash, restrict: true).count
    # ^ that is the equivalent of Employee.where("age >= 18").group(hash).count

Things seemingly work well for the most usual use-cases. Nonetheless, bug-reports are welcomed.
