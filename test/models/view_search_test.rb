# frozen_string_literal: true

require "test_helper"

class ViewSearchTest < ActiveSupport::TestCase
  test "should match a keyword in the item" do
    item = item_create!({item_title: "apple"})
    records = View.published.search("apple")

    assert_equal item, records.first, "Item was not found"
  end

  test "when given two keywords match both" do
    item = item_create!({item_title: "apple banana"})
    records = View.published.search("apple banana")

    assert_equal item, records.first, "Item was not found"
  end

  test "when given two keywords and one does not match, match nothing" do
    item_create!({item_title: "apple banana"})
    records = View.published.search("apple cherry")

    assert_empty records, "Item should not have been found"
  end

  test "should result all records for nil queries" do
    records = View.published.search(nil)

    assert_not_equal 0, records.count, "No records found"
  end

  test "should ignore whitespace" do
    item = item_create!({item_title: "apple"})
    records = View.published.search(" \n\t apple \t\n")

    assert_equal item, records.first, "Item was not found"
  end

  test "should ignore case in data" do
    item = item_create!({item_title: "APPLE"})
    records = View.published.search("apple")

    assert_equal item, records.first, "Item was not found"
  end

  test "should ignore case in query" do
    item = item_create!({item_title: "apple"})
    records = View.published.search("APPLE")

    assert_equal item, records.first, "Item was not found"
  end

  test "should ignore deleted items" do
    Item.create!(
      data: {
        item_title: "apple"
      },
      item_set: item_sets(:orphan),
      deleted_at: Time.now
    )
    records = View.published.search("apple")

    assert_empty records, "records were not empty"
  end

  test "should match two keywords in a single item" do
    item = item_create!({item_title: "apple banana"})
    records = View.published.search("apple banana")

    assert_equal item, records.first, "Item was not found"
  end

  test "should match two keywords in a single item spread over multiple data fields" do
    item = item_create!({item_title: "apple", item_comment: "banana"})
    records = View.published.search("apple banana")

    assert_equal item, records.first, "Item was not found"
  end

  test "should match numbers" do
    item = item_create!({item_title: "apple banana", number: 5001})
    records = View.published.search("5001")

    assert_equal item, records.first, "Item was not found"
  end

  test "should find fields with prefixes without spaces" do
    item = item_create!({item_title: "cherry", prefix: "A", number: 5001})
    records = View.published.search("A5001")

    assert_equal item, records.first, "Item was not found"
  end

  test "should find fields with suffixes without spaces" do
    item = item_create!({item_title: "cherry", number: 5001, in_set: "Z"})
    records = View.published.search("5001Z")

    assert_equal item, records.first, "Item was not found"
  end

  test "should sort by the default sort order" do
    9.downto(1) { |n| item_create!({item_title: "#{n} apple(s)"}) }

    records = View.published.search("apple")

    assert_equal records.first.data["item_title"],
      "1 apple(s)",
      "Wrong first item"
    assert_equal records.last.data["item_title"],
      "9 apple(s)",
      "Wrong last item"
  end

  test "should sort by numeric values" do
    9.downto(1) { |n| item_create!({item_title: "apple", number: n}) }

    records = View.published.search("apple")

    assert_equal records.first.data["number"], 1, "Wrong first item"
    assert_equal records.last.data["number"], 9, "Wrong last item"
  end

  test "should filter title by 'contains'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "lunch")
    item = item_create!({item_title: "breakfastlunchdinner"})

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter title by 'does not contain'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:number), operator: "=", value: "5")
    Filter.create!(view: view, field: fields(:item_title), operator: "does not contain", value: "lunch")
    item_create!({item_title: "breakfastlunchdinner", number: 5})
    item = item_create!({item_title: "zebra", number: 5})

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter title by 'is'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:number), operator: "=", value: "5")
    Filter.create!(view: view, field: fields(:item_title), operator: "is", value: "zebra")
    item_create!({item_title: "elk", number: 5})
    item = item_create!({item_title: "zebra", number: 5})

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter title by 'is not'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:number), operator: "=", value: "5")
    Filter.create!(view: view, field: fields(:item_title), operator: "is not", value: "zebra")
    item_create!({item_title: "zebra", number: 5})
    item = item_create!({item_title: "elk", number: 5})

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter title by 'is empty'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:prefix), operator: "is empty")
    first_item = item_create!({item_title: "zebra1", prefix: nil, number: 1})
    second_item = item_create!({item_title: "zebra2", number: 2})

    records = view.search("")

    assert_equal records, [first_item, second_item], "Item was not found"
  end

  test "should filter title by 'is not empty'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:prefix), operator: "is not empty")
    item_create!({item_title: "zebra1", number: 1})
    item = item_create!({item_title: "zebra2", prefix: "A", number: 2})

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter featured by 'is checked'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:featured), operator: "is checked")
    item_create!({item_title: "zebra1", feature: false, number: 1})
    item = item_create!({item_title: "zebra2", featured: true, number: 2})

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter featured by 'is not checked'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:featured), operator: "is not checked")
    item_create!({item_title: "zebra1", featured: true, number: 1})
    first_item = item_create!({item_title: "zebra2", number: 2})
    second_item = item_create!({item_title: "zebra3", featured: false, number: 3})

    records = view.search("")

    assert_equal records, [first_item, second_item], "Item was not found"
  end

  test "should filter tags by 'has any of'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:tags), operator: "has any of", value: "Polo, Fox Hunting")
    item_create!({item_title: "zebra1", tags: ["Football"], number: 1})
    first_item = item_create!({item_title: "zebra2", tags: ["Golf", "Polo"], number: 2})
    second_item = item_create!({item_title: "zebra3", tags: ["Fox Hunting", "Queen"], number: 3})

    records = view.search("")

    assert_equal records, [first_item, second_item], "Item was not found"
  end

  test "should filter tags by 'has all of'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:tags), operator: "has all of", value: "Polo, Fox Hunting")
    item_create!({item_title: "zebra1", tags: ["Golf", "Polo"], number: 1})
    item_create!({item_title: "zebra2", tags: ["Fox Hunting", "Queen"], number: 2})
    first_item = item_create!({item_title: "zebra2", tags: ["Fox Hunting", "Polo", "Queen"], number: 3})
    second_item = item_create!({item_title: "zebra3", tags: ["Polo", "Fox Hunting"], number: 4})

    records = view.search("")

    assert_equal records, [first_item, second_item], "Item was not found"
  end

  test "should filter tags by 'is exactly'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:tags), operator: "is exactly", value: "Polo, Fox Hunting")
    item_create!({item_title: "zebra1", tags: ["Golf", "Polo"], number: 1})
    item_create!({item_title: "zebra2", tags: ["Fox Hunting", "Queen"], number: 2})
    item_create!({item_title: "zebra2", tags: ["Fox Hunting", "Polo", "Queen"], number: 3})
    item = item_create!({item_title: "zebra3", tags: ["Fox Hunting", "Polo"], number: 4})

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter tags by 'has none of'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:tags), operator: "has none of", value: "Polo, Fox Hunting")
    item_create!({item_title: "zebra1", tags: ["Polo", "Football"], number: 1})
    item_create!({item_title: "zebra2", tags: ["Golf", "Fox Hunting"], number: 2})
    item = item_create!({item_title: "zebra3", tags: ["Golf", "Queen"], number: 3})

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter tags by 'is empty'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:tags), operator: "is empty")
    item_create!({item_title: "zebra1", tags: ["Polo", "Football"], number: 1})
    first_item = item_create!({item_title: "zebra2", tags: [], number: 2})
    second_item = item_create!({item_title: "zebra3", number: 3})
    third_item = item_create!({item_title: "zebra4", tags: nil, number: 4})

    records = view.search("")

    assert_equal records, [first_item, second_item, third_item], "Item was not found"
  end

  test "should filter tags by 'is not empty'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:tags), operator: "is not empty")
    item_create!({item_title: "zebra1", tags: [], number: 2})
    item_create!({item_title: "zebra2", number: 3})
    item_create!({item_title: "zebra3", tags: nil, number: 4})
    item = item_create!({item_title: "zebra4", tags: ["Polo", "Football"], number: 1})

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter number by '='" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:number), operator: "=", value: "5")
    item_create!({item_title: "zebra1", number: 50})
    first_item = item_create!({item_title: "zebra2", number: "5"})
    second_item = item_create!({item_title: "zebra3", number: 5})

    records = view.search("")

    assert_equal records, [first_item, second_item], "Item was not found"
  end

  test "should filter number by '≠'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:number), operator: "≠", value: "5")
    item_create!({item_title: "zebra1", number: 5})
    first_item = item_create!({item_title: "zebra2", number: "50"})
    second_item = item_create!({item_title: "zebra3", number: 50})

    records = view.search("")

    assert_equal records, [first_item, second_item], "Item was not found"
  end

  test "should filter number by '>'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:number), operator: ">", value: "5")
    item_create!({item_title: "zebra1", number: 5})
    first_item = item_create!({item_title: "zebra2", number: 6})
    second_item = item_create!({item_title: "zebra3", number: "7"})

    records = view.search("")

    assert_equal records, [first_item, second_item], "Item was not found"
  end

  test "should filter number by '<'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:number), operator: "<", value: "5")
    item_create!({item_title: "zebra1", number: 5})
    first_item = item_create!({item_title: "zebra2", number: 1})
    second_item = item_create!({item_title: "zebra3", number: "3"})

    records = view.search("")

    assert_equal records, [first_item, second_item], "Item was not found"
  end

  test "should filter number by '≥'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:number), operator: "≥", value: "5")
    item_create!({item_title: "zebra1", number: 4})
    first_item = item_create!({item_title: "zebra2", number: 5})
    second_item = item_create!({item_title: "zebra3", number: "6"})

    records = view.search("")

    assert_equal records, [first_item, second_item], "Item was not found"
  end

  test "should filter number by '≤'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:number), operator: "≤", value: "5")
    item_create!({item_title: "zebra1", number: 6})
    first_item = item_create!({item_title: "zebra2", number: "1"})
    second_item = item_create!({item_title: "zebra3", number: "5"})

    records = view.search("")

    assert_equal records, [first_item, second_item], "Item was not found"
  end

  test "should filter number by 'is empty'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:number), operator: "is empty")
    item_create!({item_title: "zebra1", number: 5})
    first_item = item_create!({item_title: "zebra2", number: nil})
    second_item = item_create!({item_title: "zebra3"})

    records = view.search("")

    assert_equal records, [first_item, second_item], "Item was not found"
  end

  test "should filter number by 'is not empty'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:number), operator: "is not empty")
    item_create!({item_title: "zebra1"})
    first_item = item_create!({item_title: "zebra2", number: 4})
    second_item = item_create!({item_title: "zebra3", number: "5"})

    records = view.search("")

    assert_equal records, [first_item, second_item], "Item was not found"
  end

  test "should filter dates by 'is'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:first_use), operator: "is", value: "29/01/1913")
    item_create!({item_title: "zebra1", first_use: "28/01/1913", number: 1}, item_sets(:orphan))
    item = item_create!({item_title: "zebra2", first_use: "29/01/1913", number: 2}, item_sets(:early_days_of_sport))

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter dates by 'is before'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:first_use), operator: "is before", value: "29/01/1913")
    item_create!({item_title: "zebra2", first_use: "29/01/1913", number: 2}, item_sets(:early_days_of_sport))
    item = item_create!({item_title: "zebra1", first_use: "28/01/1913", number: 1}, item_sets(:orphan))

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter dates by 'is after'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:first_use), operator: "is after", value: "28/01/1913")
    item_create!({item_title: "zebra1", first_use: "28/01/1913", number: 1}, item_sets(:orphan))
    item = item_create!({item_title: "zebra2", first_use: "29/01/1913", number: 2}, item_sets(:early_days_of_sport))

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter dates by 'is empty'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:first_use), operator: "is empty", value: "28/01/1913")
    item_create!({item_title: "zebra1", first_use: "28/01/1913", number: 1}, item_sets(:orphan))
    first_item = item_create!({item_title: "zebra2", first_use: "", number: 2}, item_sets(:early_days_of_sport))
    second_item = item_create!({item_title: "zebra3", first_use: nil, number: 3}, item_sets(:second_empty))
    third_item = item_create!({item_title: "zebra4", number: 4}, item_sets(:third_empty))

    records = view.search("")

    assert_equal records, [first_item, second_item, third_item], "Item was not found"
  end

  test "should filter dates by 'is not empty'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:first_use), operator: "is not empty", value: "28/01/1913")
    item = item_create!({item_title: "zebra1", first_use: "28/01/1913", number: 1}, item_sets(:orphan))
    item_create!({item_title: "zebra2", first_use: "", number: 2}, item_sets(:early_days_of_sport))
    item_create!({item_title: "zebra3", first_use: nil, number: 3}, item_sets(:second_empty))
    item_create!({item_title: "zebra4", number: 4}, item_sets(:third_empty))

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter currency by '='" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:estimated_value), operator: "=", value: "1.23")
    item_create!({item_title: "zebra1", number: 1, estimated_value: "5.49"})
    item = item_create!({item_title: "zebra2", number: 2, estimated_value: "1.23"})

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter currency by '≠'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:estimated_value), operator: "≠", value: "5.49")
    item_create!({item_title: "zebra1", number: 1, estimated_value: "5.49"})
    item = item_create!({item_title: "zebra2", number: 2, estimated_value: "1.23"})

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter currency by '>'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:estimated_value), operator: ">", value: "1.23")
    item_create!({item_title: "zebra1", number: 1, estimated_value: "1.23"})
    item = item_create!({item_title: "zebra2", number: 2, estimated_value: "1.24"})

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter currency by '<'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:estimated_value), operator: "<", value: "1.23")
    item_create!({item_title: "zebra1", number: 1, estimated_value: "1.23"})
    item = item_create!({item_title: "zebra2", number: 2, estimated_value: "1.22"})

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end

  test "should filter currency by '≥'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:estimated_value), operator: "≥", value: "1.24")
    item_create!({item_title: "zebra1", number: 1, estimated_value: "1.23"})
    first_item = item_create!({item_title: "zebra2", number: 2, estimated_value: "1.24"})
    second_item = item_create!({item_title: "zebra3", number: 3, estimated_value: "1.24"})

    records = view.search("")

    assert_equal records, [first_item, second_item], "Item was not found"
  end

  test "should filter currency by '≤'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:estimated_value), operator: "≤", value: "1.24")
    item_create!({item_title: "zebra1", number: 1, estimated_value: "1.25"})
    first_item = item_create!({item_title: "zebra2", number: 2, estimated_value: "1.24"})
    second_item = item_create!({item_title: "zebra3", number: 3, estimated_value: "1.23"})

    records = view.search("")

    assert_equal records, [first_item, second_item], "Item was not found"
  end

  test "should filter currency by 'is empty'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:estimated_value), operator: "is empty")
    item_create!({item_title: "zebra1", number: 1, estimated_value: "1.25"})
    first_item = item_create!({item_title: "zebra2", number: 2, estimated_value: ""})
    second_item = item_create!({item_title: "zebra3", number: 3, estimated_value: nil})
    third_item = item_create!({item_title: "zebra4", number: 4})

    records = view.search("")

    assert_equal records, [first_item, second_item, third_item], "Item was not found"
  end

  test "should filter currency by 'is not empty'" do
    view = views(:published)
    Filter.create!(view: view, field: fields(:item_title), operator: "contains", value: "zebra")
    Filter.create!(view: view, field: fields(:estimated_value), operator: "is not empty")
    item_create!({item_title: "zebra1", number: 1, estimated_value: ""})
    item_create!({item_title: "zebra2", number: 2, estimated_value: nil})
    item_create!({item_title: "zebra3", number: 3})
    item = item_create!({item_title: "zebra4", number: 1, estimated_value: "1.25"})

    records = view.search("")

    assert_equal records, [item], "Item was not found"
  end
end
