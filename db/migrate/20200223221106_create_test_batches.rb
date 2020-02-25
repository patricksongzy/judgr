class CreateTestBatches < ActiveRecord::Migration[6.0]
  def change
    create_table :problems do |t|
      t.string :name
      t.text :description
      
      t.timestamps
    end

    create_table :test_batches do |t|
      t.belongs_to :problem

      t.timestamps
    end
  end
end
