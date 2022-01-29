class Version < ApplicationRecord
  has_one :user
  belongs_to :model, polymorphic: true

  # Warning when fetching the associated model with destroyed Undeletable models, use class.unscoped.
  # Example: Image.unscoped { version.associated }
  belongs_to :associated, polymorphic: true, optional: true

  before_create :set_data, :set_version_number

  attr_accessor :model_changes, :columns_to_version

  validates :model, presence: true

  def self.jsonb_columns_to_ignore
    Field::RESERVED_KEYS
  end

  private

  def column_types
    model
      .class
      .column_names
      .map { |name| [name, type_for_attribute(name).type] }
      .to_h
  end

  def set_data
    self.data = generate_data
  end

  def safe_model_changes
    model_changes || {}
  end

  def safe_columns_to_version
    columns_to_version || []
  end

  def generate_data
    field_changes = {}

    safe_columns_to_version.each do |field_name|
      next unless safe_model_changes.has_key?(field_name)

      outer_name = field_name.to_s
      from_to = safe_model_changes[field_name]

      if column_types[outer_name] == :jsonb
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
    max = self.class.where(model: self.model).maximum(:version) || 0
    self.version = max + 1
  end
end
