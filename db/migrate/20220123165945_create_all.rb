class CreateAll < ActiveRecord::Migration[7.0]
  # This migration is a concatenation of all previous migrations, but with better indexes and foreign keys.
  def change
    create_table :friendly_id_slugs do |t|
      t.string :slug, null: false
      t.integer :sluggable_id, null: false
      t.string :sluggable_type, limit: 50
      t.string :scope
      t.datetime :created_at
    end
    add_index :friendly_id_slugs, %i[sluggable_type sluggable_id]
    add_index :friendly_id_slugs,
              %i[slug sluggable_type],
              length: {
                slug: 140,
                sluggable_type: 50
              }
    add_index :friendly_id_slugs,
              %i[slug sluggable_type scope],
              length: {
                slug: 70,
                sluggable_type: 50,
                scope: 70
              },
              unique: true

    create_table :users do |t|
      ## Database authenticatable
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      ## Confirmable
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email # Only if using reconfirmable

      ## Invitable
      t.string :invitation_token
      t.datetime :invitation_created_at
      t.datetime :invitation_sent_at
      t.datetime :invitation_accepted_at
      t.integer :invitation_limit
      t.integer :invited_by_id
      t.string :invited_by_type

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    # add_index :users, :unlock_token,         unique: true
    #
    create_table :views do |t|
      t.string :title
      t.boolean :default, default: false
      t.datetime :deleted_at, index: true
      t.timestamps
    end

    create_table :fields do |t|
      t.string :title
      t.string :key
      t.string :column_type
      t.boolean :permanent, default: false
      t.boolean :publish, default: true
      t.boolean :same_across_set, default: false
      t.boolean :item_identifier, default: false
      t.references :prefix_field, null: true, foreign_key: { to_table: 'fields' }
      t.references :suffix_field, null: true, foreign_key: { to_table: 'fields' }
      t.datetime :deleted_at, index: true
      t.timestamps
    end

    create_table :item_sets do |t|
      t.string :title, index: { unique: true }
      t.string :slug
      t.jsonb :log, index: :gin
      t.datetime :deleted_at, index: true
      t.timestamps
    end

    create_table :items do |t|
      t.references :item_set, null: false, foreign_key: true
      t.string :slug, index: { unique: true }
      t.jsonb :data, index: :gin
      t.jsonb :log, index: :gin
      t.virtual :data_tsvector_col, :virtual, type: :tsvector, as: "to_tsvector('english', data)", stored: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end

    create_table :images do |t|
      t.references :item, null: true, foreign_key: true
      t.references :item_set, null: true, foreign_key: true
      t.integer :position
      t.datetime :deleted_at, index: true
      t.timestamps
    end

    create_table :multiple_selects do |t|
      t.references :field, null: false, foreign_key: true
      t.string :title
      t.timestamps
    end

    add_index :multiple_selects, [:field_id, :title], unique: true

    create_table :pages do |t|
      t.string :title
      t.string :slug, index: { unique: true }
      t.jsonb :log, index: :gin
      t.datetime :deleted_at, index: true
      t.timestamps
    end

    create_table :single_selects do |t|
      t.references :field, null: false, foreign_key: true
      t.string :title
      t.timestamps
    end

    add_index :single_selects, [:field_id, :title], unique: true

    create_table :sorts, force: :cascade do |t|
      t.references :view, null: false, foreign_key: true
      t.references :field, null: false, foreign_key: true
      t.string :direction
      t.integer :position
      t.timestamps
    end

    create_table :view_fields do |t|
      t.references :view, null: false, foreign_key: true
      t.references :field, null: false, foreign_key: true
      t.integer :position, index: true
    end

    add_index :view_fields, [:view_id, :field_id], unique: true
  end
end