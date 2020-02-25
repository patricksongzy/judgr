class AddProblemIdToSubmission < ActiveRecord::Migration[6.0]
  def change
    add_reference :submissions, :problem, foreign_key: true
  end
end
