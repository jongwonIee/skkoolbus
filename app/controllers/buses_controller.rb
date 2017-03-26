class BusesController < ApplicationController
  include BusesHelper
  def index
    #gem 이 작동시키도록 수정
    api
  if @@carNumber[0] == "" and @@carNumber[1] == "" and @@carNumber[2] == "" and @@carNumber[3] == "" and @@carNumber[4] == "" and @@carNumber[5] == "" and @@carNumber[6] == "" and @@carNumber[7] == "" and @@carNumber[8] == "" and @@carNumber[9] == ""
    redirect_to '/schedule'
  end
  end

  def scheduler_test
    scheduler = Rufus::Scheduler.new
    i = 0
    scheduler.every '1s' do
      puts i
      i += 1
      if i == 10
        scheduler.stop
        puts "S,stop"
        scheduler.shutdown
        puts "S,shutdown"
      end
    end
    puts "Action completed"
  end

  def set_stations
  @@stations = {1 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}},
                2 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}},
                3 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}},
                4 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}},
                5 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}},
                6 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}},
                7 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}},
                8 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}},
                9 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}},
                10 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}}
                }
  end
  def api_test3
    scheduler = Rufus::Scheduler.new
    scheduler.every '1s' do
    puts "Start"
    response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
    @@stations = Predict.second.stations
    for i in (0..response.size-1) 
      json = response[i]
      carnumber = json["CarNumber"]
      sequence = json["Sequence"]
      current_status = json["Kind"].to_i
      station = @@stations[sequence]
      #Check sequence because before_station could be -1
      if sequence == 1
        before_station = @@stations[10]
      else
        before_station = @@stations[sequence - 1]
      end

      if carnumber.length > 0 and station[:carnumber].length > 0 and station[:carnumber] != carnumber
        check_stop_time(carnumber, station)
        taked_time = calculate_time_taken(carnumber,station, before_station, 2, 0)
        station[:before_car] = station[:carnumber]
        Car.create(carnumber: carnumber, arrived: Time.now, difference: (Time.now - station[:time_stop][station[:before_car]]), sequence: sequence, taked_time: taked_time)

      elsif carnumber.length == 0 and station[:carnumber].length > 0 
        station[:before_car] = station[:carnumber]

      elsif carnumber.length >0 and station[:carnumber].length == 0
        check_stop_time(carnumber, station)
        taked_time = calculate_time_taken(carnumber,station, before_station, 2, 0)
        Car.create(carnumber: carnumber, arrived: Time.now, difference: (Time.now - station[:time_stop][station[:before_car]]), sequence: sequence, taked_time: taked_time)
      end
      station[:carnumber] = carnumber
      save_status(station, current_status)
      station[:average_time2] = (station[:time_taken2].sum / station[:time_taken2].size)
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
        if selected_station[:carnumber].length > 0
          puts "Current_stations: #{current_sequence}"
          puts "nearest_stations: #{selected}"
          puts "status: #{selected_station[:status].to_i}"
          nearest_station = {}
          nearest_station[:sequence] = selected 
          nearest_station[:type] = selected_station[:carnumber]
          #Calculated before?
          if calculated[:sequence] == nearest_station[:sequence] and calculated[:type] != nearest_station[:type]
              total_time = sum_stations(index, current_sequence - 1, sequences, @@stations, 0, 2)
              @@stations[current_sequence][:time_arrival2] = Time.now + total_time
              @@stations[current_sequence][:calculated][:sequence] = nearest_station[:sequence]
              @@stations[current_sequence][:calculated][:type] = nearest_station[:type]
          elsif calculated[:sequence] != nearest_station[:sequence]
              total_time = sum_stations(index, current_sequence - 1, sequences, @@stations, 0, 2)
              @@stations[current_sequence][:time_arrival2] = Time.now + total_time
              @@stations[current_sequence][:calculated][:sequence] = nearest_station[:sequence]
              @@stations[current_sequence][:calculated][:type] = nearest_station[:type]
          end
          puts "calculated[:sequence] : #{calculated[:sequence]}"
          puts "total_time: #{total_time}"
          puts "sum_stations: #{index}, #{(current_sequence-1)}, #{sequences} "
          break
        else
        end
      end    
    end
    @stations = @@stations
    Predict.second.update_attributes(stations: @@stations)
    puts "end"
    end
  end

  def api_test2
    puts "Start"
    response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
    @@stations = Predict.second.stations
    for i in (0..response.size-1) 
      json = response[i]
      carnumber = json["CarNumber"]
      sequence = json["Sequence"]
      current_status = json["Kind"].to_i
      station = @@stations[sequence]
      #Check sequence becuase before_station could be -1
      if sequence == 1
        before_station = @@stations[10]
      else
        before_station = @@stations[sequence - 1]
      end

      if carnumber.length > 0 and station[:carnumber].length > 0 and station[:carnumber] != carnumber
        check_stop_time(carnumber, station)
        taked_time = calculate_time_taken(carnumber,station, before_station, 2, 0)
        station[:before_car] = station[:carnumber]
        Car.create(carnumber: carnumber, arrived: Time.now, difference: (Time.now - station[:time_stop][station[:before_car]]), sequence: sequence, taked_time: taked_time)

      elsif carnumber.length == 0 and station[:carnumber].length > 0 
        station[:before_car] = station[:carnumber]

      elsif carnumber.length >0 and station[:carnumber].length == 0
        check_stop_time(carnumber, station)
        taked_time = calculate_time_taken(carnumber,station, before_station, 2, 0)
        Car.create(carnumber: carnumber, arrived: Time.now, difference: (Time.now - station[:time_stop][station[:before_car]]), sequence: sequence, taked_time: taked_time)
      end
      station[:carnumber] = carnumber
      save_status(station, current_status)
      station[:average_time2] = (station[:time_taken2].sum / station[:time_taken2].size)
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
        if selected_station[:carnumber].length > 0
          puts "Current_stations: #{current_sequence}"
          puts "nearest_stations: #{selected}"
          puts "status: #{selected_station[:status].to_i}"
          nearest_station = {}
          nearest_station[:sequence] = selected 
          nearest_station[:type] = selected_station[:carnumber]
          #Calculated before?
          if calculated[:sequence] == nearest_station[:sequence] and calculated[:type] != nearest_station[:type]
              total_time = sum_stations(index, current_sequence - 1, sequences, @@stations, 0, 2)
              @@stations[current_sequence][:time_arrival2] = Time.now + total_time
              @@stations[current_sequence][:calculated][:sequence] = nearest_station[:sequence]
              @@stations[current_sequence][:calculated][:type] = nearest_station[:type]
          elsif calculated[:sequence] != nearest_station[:sequence]
              total_time = sum_stations(index, current_sequence - 1, sequences, @@stations, 0, 2)
              @@stations[current_sequence][:time_arrival2] = Time.now + total_time
              @@stations[current_sequence][:calculated][:sequence] = nearest_station[:sequence]
              @@stations[current_sequence][:calculated][:type] = nearest_station[:type]
          end
          puts "calculated[:sequence] : #{calculated[:sequence]}"
          puts "total_time: #{total_time}"
          puts "sum_stations: #{index}, #{(current_sequence-1)}, #{sequences} "
          break
        else
        end
      end    
    end
    @stations = @@stations
    Predict.second.update_attributes(stations: @@stations)
    puts "end"
  end

  def api_test
    puts "Start"
    response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
    @@stations = Predict.first.stations
    for i in (0..response.size-1) 
      json = response[i]
      sequence = json["Sequence"]
      current_status = json["Kind"].to_i
      carnumber = json["CarNumber"]
      station = @@stations[sequence]
      #Check sequence becuase before_station could be -1
      if sequence == 1
        before_station = @@stations[10]
      else
        before_station = @@stations[sequence - 1]
      end
      #1. Bus arrived and stop
      if station[:existence] == 0 and current_status == 2
        calculate_time_taken(carnumber,station, before_station, 1, 0)
        check_stop_time(carnumber, station)
        change_existence(station, 1)
      #2. Bus arrived and depart right away
      elsif station[:existence] == 0 and current_status == 3
        calculate_time_taken(carnumber,station, before_station, 1, 0)
        check_depart_time(station)
        calculate_time_spent(carnumber,station, "nonstop")
        change_existence(station, 2)
      #3. Bus stop and depart
      elsif station[:existence] == 1 and current_status == 3
        calculate_time_spent(carnumber,station, "stop")
        check_depart_time(station)
        change_existence(station, 2)
      #4. Bus stop and vanish
      elsif station[:existence] == 1 and current_status == 0
        calculate_time_spent(carnumber,station, "stop")
        check_depart_time(station)
        change_existence(station, 0)
      #5. Every thing is done
      elsif station[:existence] == 2 and current_status == 0
        change_existence(station, 0)
      #6. Bus stop after right away Bus goes
      elsif station[:existence] == 2 and current_status == 2
        calculate_time_taken(carnumber,station, before_station, 1, 0)
        check_stop_time(carnumber, station)
        change_existence(station, 1) 
      #7. um....
      else
        #Do nothing
      end
      save_status(station, current_status)
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
        if selected_station[:status].to_i == 2 || selected_station[:status].to_i == 3
          puts "Current_stations: #{current_sequence}"
          puts "nearest_stations: #{selected}"
          puts "status: #{selected_station[:status].to_i}"
          nearest_station = {}
          nearest_station[:sequence] = selected 
          nearest_station[:type] = selected_station[:status]
          #Calculated before?
          if calculated[:sequence] == nearest_station[:sequence]
            if calculated[:type] == nearest_station[:type]
              #Bye
            elsif calculated[:type] < nearest_station[:type]
              total_time = sum_stations(index, current_sequence - 1, sequences, @@stations, 3, 1)
              @@stations[current_sequence][:time_arrival2] =  Time.now + total_time
              @@stations[current_sequence][:calculated][:type] = 3 
            end
          elsif calculated[:sequence] != nearest_station[:sequence]
            if nearest_station[:type] == 2
              total_time = sum_stations(index, current_sequence - 1, sequences, @@stations, 2, 1)
              @@stations[current_sequence][:time_arrival2] = Time.now + total_time
              @@stations[current_sequence][:calculated][:sequence] = nearest_station[:sequence]
              @@stations[current_sequence][:calculated][:type] = 2
            else
              total_time = sum_stations(index, current_sequence - 1, sequences, @@stations, 3, 1)
              @@stations[current_sequence][:time_arrival] = Time.now + total_time
              @@stations[current_sequence][:calculated][:sequence] = nearest_station[:sequence]
              @@stations[current_sequence][:calculated][:type] = 3 
            end
          end
          puts "calculated[:sequence] : #{calculated[:sequence]}"
          puts "total_time: #{total_time}"
          puts "sum_stations: #{index}, #{(current_sequence-1)}, #{sequences}, #{nearest_station[:type]}"
          break
        else
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
