class Predict < ApplicationRecord
  serialize :stations
  def self.setup
    c = BusesController.new
    @stations = c.set_stations
    self.destroy_all
    self.create(stations:@stations)
    self.create(stations:@stations)
  end
end
