class Log < ApplicationRecord
  has_one :user
  belongs_to :model, polymorphic: true, optional: true

  # This relationship will not return soft deleted records (Undeletable), please use unscoped_associated for destroyed records.
  belongs_to :associated, polymorphic: true, optional: true

  before_create :set_entry, :set_version_number

  attr_accessor :loggable_changes, :importing

  validates :model, presence: true, unless: lambda { |log| log.importing }

  scope :newest_to_oldest, -> { order(version: :desc, created_at: :desc) }

  def unscoped_associated
    associated_type.constantize.unscoped { associated }
  end

  def self.rebuild_data_from_logs(model)
    data = {}

    where(model: model)
      .newest_to_oldest
      .each do |log|
        log
          .entry
          .select { |k, _v| k.starts_with?('data.') }
          .each { |k, v| data[k.split('.').last] = v.second }
      end

    data
  end

  private

  def set_entry
    return if importing

    self.entry = generate_entry
  end

  def safe_loggable_changes
    loggable_changes || {}
  end

  def generate_entry
    field_changes = {}

    safe_loggable_changes.each do |field_name, from_to|
      outer_name = field_name.to_s

      if column_type(outer_name) == :jsonb
        model[field_name].each do |inner_name, inner_to|
          next if self.class.jsonb_columns_to_ignore.include?(inner_name)
          inner_from = from_to.first.try(:[], inner_name)
          next if inner_from == inner_to

          field_changes["#{outer_name}.#{inner_name}"] = [inner_from, inner_to]
        end
      else
        field_changes[outer_name] = from_to
      end
    end

    field_changes
  end

  def set_version_number
    return if importing

    max = self.class.where(model: self.model).maximum(:version) || 0
    self.version = max + 1
  end

  def self.jsonb_columns_to_ignore
    Field::RESERVED_KEYS
  end

  def column_type(name)
    model.type_for_attribute(name).type
  end
end
