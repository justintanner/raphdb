module ItemCreateHelper
  def item_create!(fields = {}, item_set = nil)
    item_set ||= item_sets(:default)

    Item.create!(fields: fields, item_set: item_set)
  end
end
