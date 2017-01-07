class BusesController < ApplicationController
  def index
    response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
    for n in [1,2,3,4,5,6,7,8,9,10]
      @json = response[n-1],
      instance_variable_set("@json#{n}", response[n-1]),
      instance_variable_set("@sequence#{n}", response[n-1]["Sequence"]),
      instance_variable_set("@stationName#{n}", response[n-1]["StationName"]),
      instance_variable_set("@eventDate#{n}", response[n-1]["EventDate"]),
      instance_variable_set("@kind#{n}", response[n-1]["Kind"]),
      instance_variable_set("@useTime#{n}", response[n-1]["usetime"]),
      instance_variable_set("@carNumber#{n}", response[n-1]["CarNumber"])
    end
  end
end