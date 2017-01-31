class CreateBuses < ActiveRecord::Migration[5.0]
  def change
    create_table :buses do |t|

      t.integer :s1
      t.integer :s2
      t.integer :s3
      t.integer :s4
      t.integer :s5
      t.integer :s6
      t.integer :s7
      t.integer :s8
      t.integer :s9
      t.integer :s10

      t.timestamps
    end
  end
end