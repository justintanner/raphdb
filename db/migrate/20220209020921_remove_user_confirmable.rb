# frozen_string_literal: true

class RemoveUserConfirmable < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :confirmation_token
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_sent_at
    remove_column :users, :unconfirmed_email
  end
end
