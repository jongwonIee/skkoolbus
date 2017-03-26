class CreateTestSchedulers < ActiveRecord::Migration[5.0]
  def change
    create_table :test_schedulers do |t|
      t.integer :count
      t.datetime :time

      t.timestamps
    end
  end
end
