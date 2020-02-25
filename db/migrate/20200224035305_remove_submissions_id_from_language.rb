class RemoveSubmissionsIdFromLanguage < ActiveRecord::Migration[6.0]
  def change

    remove_column :languages, :submissions_id, :integer
  end
end
