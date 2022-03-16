# frozen_string_literal: true

module ItemsHelper
  def position
    return 1 unless params.key?(:picture_number)

    params[:picture_number].to_i
  end
end
