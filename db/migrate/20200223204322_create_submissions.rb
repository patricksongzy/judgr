class CreateSubmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :submissions do |t|
      t.string :language
      t.text :code

      t.timestamps
    end
  end
end
