class AddContestToProblem < ActiveRecord::Migration[6.0]
  def change
    add_reference :problems, :contest, foreign_key: true
  end
end
