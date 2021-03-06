# frozen_string_literal: true

namespace :pg do
  task reset_sequences: :environment do
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
  end
end
