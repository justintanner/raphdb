require 'test_helper'

class FieldTest < ActiveSupport::TestCase
  test 'leaves booleans untouched' do
    assert_equal false,
                 Clean.clean_and_format(fields(:featured).key, false),
                 'Meddled with a boolean'
  end

  test 'saves boolean values of false' do
    item = Item.new(data: { featured: false })

    Clean.attribute(item, 'data', :jsonb)

    assert_equal false, item.data['featured'], 'Boolean was not saved'
  end
end
