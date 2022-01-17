require 'active_support/concern'

# TODO: What should search do about quotations?
module Search
  extend ActiveSupport::Concern

  class_methods do
    def search(query, options = {})
      SearchProcessor.query(query, self, options)
    end
  end
end

module SearchProcessor
  MAX_RESULTS = 200
  DEFAULT_PER_PAGE = 100

  def self.query(query, klass, options)
    return if query.blank?

    klass
      .includes(:item_set, :images)
      .where("fields_tsvector_col @@ to_tsquery('english', ?)", tsquery(query))
      .offset(offset(options[:page], options[:per_page]))
      .limit(limit(options[:per_page]))
  end

  def self.offset(page, per_page)
    page.is_a?(Numeric) && page >= 1 ? (page - 1) * limit(per_page) : 0
  end

  def self.limit(per_page)
    if per_page.is_a?(Numeric) && per_page > 0 && per_page <= MAX_RESULTS
      per_page
    else
      DEFAULT_PER_PAGE
    end
  end

  def self.tsquery(query)
    query.gsub(/[[:space:]]+/, ' ').strip.gsub(/[[:space:]]/, '|')
  end
end
