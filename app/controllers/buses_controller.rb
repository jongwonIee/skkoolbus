class BusesController < ApplicationController
  include BusesHelper
  def index
    #gem 이 작동시키도록 수정
    api
  if @@carNumber[0] == "" and @@carNumber[1] == "" and @@carNumber[2] == "" and @@carNumber[3] == "" and @@carNumber[4] == "" and @@carNumber[5] == "" and @@carNumber[6] == "" and @@carNumber[7] == "" and @@carNumber[8] == "" and @@carNumber[9] == ""
    redirect_to '/schedule'
  end
  end

  def set_stations
  @@stations = {1 => {existence: 0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, time_spent: [1], average_time_spent: 0, time_stop: 0, time_arrival: 0, calculated:{sequence: 0, type:0}},
                2 => {existence: 0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, time_spent: [1], average_time_spent: 0, time_stop: 0, time_arrival: 0, calculated:{sequence: 0, type:0}},
                3 => {existence: 0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, time_spent: [1], average_time_spent: 0, time_stop: 0, time_arrival: 0, calculated:{sequence: 0, type:0}},
                4 => {existence: 0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, time_spent: [1], average_time_spent: 0, time_stop: 0, time_arrival: 0, calculated:{sequence: 0, type:0}},
                5 => {existence: 0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, time_spent: [1], average_time_spent: 0, time_stop: 0, time_arrival: 0, calculated:{sequence: 0, type:0}},
                6 => {existence: 0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, time_spent: [1], average_time_spent: 0, time_stop: 0, time_arrival: 0, calculated:{sequence: 0, type:0}},
                7 => {existence: 0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, time_spent: [1], average_time_spent: 0, time_stop: 0, time_arrival: 0, calculated:{sequence: 0, type:0}},
                8 => {existence: 0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, time_spent: [1], average_time_spent: 0, time_stop: 0, time_arrival: 0, calculated:{sequence: 0, type:0}},
                9 => {existence: 0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, time_spent: [1], average_time_spent: 0, time_stop: 0, time_arrival: 0, calculated:{sequence: 0, type:0}},
                10 => {existence: 0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, time_spent: [1], average_time_spent: 0, time_stop: 0, time_arrival: 0, calculated:{sequence: 0, type:0}}
                }
  end

  def api_test
    puts "Start"
    response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
    @@stations = Predict.first.stations
    for i in (0..response.size-1) 
      json = response[i]
      sequence = json["Sequence"]
      current_status = json["Kind"]
      station = @@stations[sequence]
      #Check sequence becuase before_station could be -1
      if sequence == 1
        before_station = @@stations[10]
      else
        before_station = @@stations[sequence - 1]
      end
      #Stop(2) -> Departure(3)
      if current_status.to_i - station[:status].to_i == 1
        station[:time_depart] = Time.now
        station[:status] = current_status.to_i
        if station[:time_spent].size < 3
          station[:time_spent] << (Time.now - station[:time_stop])
        else 
          station[:time_spent].shift
          station[:time_spent] << (Time.now - station[:time_stop])
        end
      #Nothing -> Stop
      elsif json["CarNumber"].length > 0 and station[:existence] == 0
        station[:time_stop] = Time.now
        #Limit array size
        if station[:time_taken].size < 3
          station[:time_taken] << Time.now - before_station[:time_depart] 
        else 
          station[:time_taken].shift 
          station[:time_taken] << Time.now - before_station[:time_depart]
        end
        station[:status] = current_status.to_i
        station[:existence] = 1
      elsif json["CarNumber"].length == 0
        station[:existence] = 0
      else 
        station[:status] = current_status.to_i
      end
      station[:average_time] = (station[:time_taken].sum / station[:time_taken].size)
      station[:average_time_spent] = (station[:time_spent].sum / station[:time_spent].size)
    end

    for i in (0..response.size-1) 
      json = response[i]
      current_sequence = json["Sequence"]
      current_station = @@stations[current_sequence]
      calculated = current_station[:calculated]
      sequences = (1..10).to_a
      for x in (1..10)
        index = current_sequence - 1 - x
        selected = sequences[index]
        selected_station = @@stations[selected]
        if selected_station[:status].to_i == (2 || 3)
          nearest_station = {}
          nearest_station[:sequence] = selected 
          nearest_station[:type] = selected_station[:status]
          #Calculated before?
          if calculated[:sequence] == nearest_station[:sequence]
            if calculated[:type] == nearest_station[:type]
              #Bye
            elsif calculated[:type] < nearest_station[:type]
              total_time = sum_stations(index, current_sequence - 1, sequences, @@stations, 3)
              @@stations[current_sequence][:time_arrival] =  Time.now + total_time
              @@stations[:calculated] = 3 
            end
          elsif calculated[:sequence] != nearest_station[:sequence]
            if nearest_station[:type] == 2
              total_time = sum_stations(index, current_sequence - 1, sequences, @@stations, 2)
              @@stations[current_sequence][:time_arrival] = Time.now + total_time
              @@stations[:calculated] = 2
            else
              total_time = sum_stations(index, current_sequence - 1, sequences, @@stations, 3)
              @@stations[current_sequence][:time_arrival] = Time.now + total_time
              @@stations[:calculated] = 3
            end
          end
        end
      end    
    end
    @stations = @@stations
    Predict.first.update_attributes(stations: @@stations)
    puts "end"
  end
def api
  #api call - 초단위 갱신
  response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
  @@json = []
  @@sequence = []
  @@kind = []
  @@carNumber = []
  @@expect = []
  #if no overlap
  if response[10].nil?
    @@overlap = false
    for n in [1,2,3,4,5,6,7,8,9,10]
      @@json = response[n-1],
      @@sequence << response[n-1]["Sequence"],
      @@kind << response[n-1]["Kind"],
      @@carNumber << response[n-1]["CarNumber"],
      @@expect << Bus.expect(n)
    end
    #if overlap
  else #overlap
    @@overlap = true
    for n in [1,2,3,4,5,6,7,8,9,10,11]
      @@json = response[n-1],
      @@sequence << response[n-1]["Sequence"],
      @@kind << response[n-1]["Kind"],
      @@carNumber << response[n-1]["CarNumber"],
      @@expect << Bus.expect2(n)
    end
  end
end
end
