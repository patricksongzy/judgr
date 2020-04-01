class AddConfirmationToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email_confirmed_at, :integer
    add_column :users, :email_confirmation_token, :string
  end
end
