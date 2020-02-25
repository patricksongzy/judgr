class AddLanguageIdToSubmission < ActiveRecord::Migration[6.0]
  def change
    add_reference :submissions, :language, foreign_key: true
  end
end
