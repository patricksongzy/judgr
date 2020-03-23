class AddTimesToContest < ActiveRecord::Migration[6.0]
  def change
    add_column :contests, :start_datetime, :integer
    add_column :contests, :end_datetime, :integer
  end
end
