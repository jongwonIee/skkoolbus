class CreateCars < ActiveRecord::Migration[5.0]
  def change
    create_table :cars do |t|
      t.string :carnumber
      t.datetime :arrived
      t.integer :taked_time
      t.integer :difference
      t.integer :sequence

      t.timestamps
    end
  end
end
