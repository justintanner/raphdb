module ImageHelper
  def srcset(image, *sizes)
    sizes
      .map { |variant| "#{url_for(image.file.variant(variant))} #{image.width(variant)}w" }
      .join(",")
  end
end
