# frozen_string_literal: true

require "ruby-prof"
require "benchmark"

module Bench
  def self.measure_and_profile(name, n, measure_lambda, cleanup_lambda)
    puts "Profiling #{name} #{n} times, stopping this task will pollute the dev database..."

    result = RubyProf.profile { measure_lambda.call(n) }

    graph_filename =
      Rails.root.join("tmp", "#{name.parameterize(separator: "_")}_graph.html")
    puts "Saving results to #{graph_filename}"

    File.open graph_filename, "w" do |file|
      RubyProf::GraphHtmlPrinter.new(result).print(file)
    end

    cleanup_lambda.call(n)

    time = Benchmark.measure { measure_lambda.call(n) }

    puts "#{name} #{n} times took #{time.real} seconds."

    cleanup_lambda.call(n)
  end
end
