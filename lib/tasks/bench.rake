require 'bench'

namespace :bench do
  task item_create: :environment do
    return unless Rails.env.development?

    measure_lambda =
      lambda do |n|
        item_set = ItemSet.create!(title: 'Bench Set')
        n.times.map do |index|
          Item.create!(
            fields: {
              item_title: "Bench Item #{index}"
            },
            item_set: item_set
          )
        end
      end

    cleanup_lambda =
      lambda do |_n|
        item_set = ItemSet.find_by(title: 'Bench Set')
        item_set.items.each { |item| item.destroy_fully! }
        item_set.destroy_fully!
      end

    Bench.measure_and_profile(
      'Item creation',
      500,
      measure_lambda,
      cleanup_lambda
    )
  end

  task item_update: :environment do
    return unless Rails.env.development?

    measure_lambda =
      lambda do |n|
        item_set = ItemSet.create!(title: 'Bench Set')
        item =
          Item.create!(
            fields: {
              item_title: 'Bench Item',
              number: 0
            },
            item_set: item_set
          )
        n.times.map { |index| item.update(fields: { number: index }) }
      end

    cleanup_lambda =
      lambda do |_n|
        item_set = ItemSet.find_by(title: 'Bench Set')
        item_set.items.each { |item| item.destroy_fully! }
        item_set.destroy_fully!
      end

    Bench.measure_and_profile(
      'Item updating',
      1000,
      measure_lambda,
      cleanup_lambda
    )
  end

  task item_search: :environment do
    return unless Rails.env.development?

    measure_lambda =
      lambda do |n|
        item_set = ItemSet.create!(title: 'Bench Set')
        item =
          Item.create!(
            fields: {
              item_title: 'Bench Item Apple'
            },
            item_set: item_set
          )
        n.times.map { Item.search('apple') }
      end

    cleanup_lambda =
      lambda do |_n|
        item_set = ItemSet.find_by(title: 'Bench Set')
        item_set.items.each { |item| item.destroy_fully! }
        item_set.destroy_fully!
      end

    Bench.measure_and_profile(
      'Item searching',
      1000,
      measure_lambda,
      cleanup_lambda
    )
  end
end
