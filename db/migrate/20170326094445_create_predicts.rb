class CreatePredicts < ActiveRecord::Migration[5.0]
  def change
    create_table :predicts do |t|
      t.text :stations

      t.timestamps
    end
  end
end