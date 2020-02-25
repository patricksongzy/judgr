class RemoveLanguageIdFromSubmission < ActiveRecord::Migration[6.0]
  def change
    remove_column :submissions, :language_id, :integer
  end
end
