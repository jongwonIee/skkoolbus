class AddSequenceToCars < ActiveRecord::Migration[5.0]
  def change
    add_column :cars, :sequence, :integer
  end
end
