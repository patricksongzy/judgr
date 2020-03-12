class AddScoreToSubmission < ActiveRecord::Migration[6.0]
  def change
    add_column :submissions, :message, :string
    add_column :submissions, :score, :integer
  end
end
