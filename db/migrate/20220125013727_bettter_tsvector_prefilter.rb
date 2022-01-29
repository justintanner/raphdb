class BettterTsvectorPrefilter < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :data_tsvector_col

    # Forces space between non-alpha-numeric characters to help with full-text searching.
    # Example "123/456" becomes "123 / 456" which allow the the tokens "123" and "456" to be indexed.
    add_column :items,
               :data_tsvector_col,
               :virtual,
               type: :tsvector, as: "to_tsvector('english', regexp_replace(data::text, '([^a-z0-9]+)', ' \\1 ', 'gi')::jsonb)", stored: true
  end
end
