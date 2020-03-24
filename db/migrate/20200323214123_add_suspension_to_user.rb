class AddSuspensionToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_suspended, :boolean, default: false
    add_column :users, :last_request, :integer
  end
end
