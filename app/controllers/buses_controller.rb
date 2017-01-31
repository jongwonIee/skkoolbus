class BusesController < ApplicationController
  def index
    response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
    if response[10] == nil
      @overlap = false
      for n in [1,2,3,4,5,6,7,8,9,10]
        @json = response[n-1],
            instance_variable_set("@json#{n}", response[n-1]),
            instance_variable_set("@sequence#{n}", response[n-1]["Sequence"]),
            instance_variable_set("@stationName#{n}", response[n-1]["StationName"]),
            instance_variable_set("@eventDate#{n}", response[n-1]["EventDate"]),
            instance_variable_set("@kind#{n}", response[n-1]["Kind"]),
            instance_variable_set("@useTime#{n}", response[n-1]["usetime"]),
            instance_variable_set("@carNumber#{n}", response[n-1]["CarNumber"]),
            instance_variable_set("@expect#{n}", Bus.expect(n))
      end
    else #overlap
      @overlap = true
      for n in [1,2,3,4,5,6,7,8,9,10,11]
        @json = response[n-1],
            instance_variable_set("@json#{n}", response[n-1]),
            instance_variable_set("@sequence#{n}", response[n-1]["Sequence"]),
            instance_variable_set("@stationName#{n}", response[n-1]["StationName"]),
            instance_variable_set("@eventDate#{n}", response[n-1]["EventDate"]),
            instance_variable_set("@kind#{n}", response[n-1]["Kind"]),
            instance_variable_set("@useTime#{n}", response[n-1]["usetime"]),
            instance_variable_set("@carNumber#{n}", response[n-1]["CarNumber"]),
            instance_variable_set("@expect#{n}", Bus.expect2(n))
      end
    end
  end

  def temp
    response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
    if response[10] == nil
      @overlap = false
      for n in [1,2,3,4,5,6,7,8,9,10]
        @json = response[n-1],
            instance_variable_set("@json#{n}", response[n-1]),
            instance_variable_set("@sequence#{n}", response[n-1]["Sequence"]),
            instance_variable_set("@stationName#{n}", response[n-1]["StationName"]),
            instance_variable_set("@eventDate#{n}", response[n-1]["EventDate"]),
            instance_variable_set("@kind#{n}", response[n-1]["Kind"]),
            instance_variable_set("@useTime#{n}", response[n-1]["usetime"]),
            instance_variable_set("@carNumber#{n}", response[n-1]["CarNumber"]),
            instance_variable_set("@expect#{n}", Bus.expect(n))
      end
    else #overlap
      @overlap = true
      for n in [1,2,3,4,5,6,7,8,9,10,11]
        @json = response[n-1],
            instance_variable_set("@json#{n}", response[n-1]),
            instance_variable_set("@sequence#{n}", response[n-1]["Sequence"]),
            instance_variable_set("@stationName#{n}", response[n-1]["StationName"]),
            instance_variable_set("@eventDate#{n}", response[n-1]["EventDate"]),
            instance_variable_set("@kind#{n}", response[n-1]["Kind"]),
            instance_variable_set("@useTime#{n}", response[n-1]["usetime"]),
            instance_variable_set("@carNumber#{n}", response[n-1]["CarNumber"]),
            instance_variable_set("@expect#{n}", Bus.expect2(n))
      end
    end
  end
end