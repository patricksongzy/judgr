class RemoveLanguageFromSubmission < ActiveRecord::Migration[6.0]
  def change

    remove_column :submissions, :language, :string
  end
end
