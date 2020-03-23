class AddRuntimeToProblem < ActiveRecord::Migration[6.0]
  def change
    add_column :problems, :uuid, :string
    add_column :problems, :time_limit, :integer, default: 2
  end
end
