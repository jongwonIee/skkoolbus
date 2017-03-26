class BusesController < ApplicationController
  include BusesHelper
  def index
    api
    estimations
  end

  def api
    #api call - by user
    # response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
    response =  JSON.parse(File.read('app/views/buses/response.json'))
    if response[2]["CarNumber"] == "" and response[3]["CarNumber"] == "" and response[4]["CarNumber"] == "" and response[5]["CarNumber"] == "" and response[6]["CarNumber"] == "" and response[7]["CarNumber"] == "" and response[8]["CarNumber"] == "" and response[9]["CarNumber"] == ""
      @on = false
    else
      @on = true
      @json = []
      @sequence = []
      @kind = []
      @carNumber = []
      @expect = []
      #if no overlap
      if response[10].nil?
        @overlap = false
        for n in [1,2,3,4,5,6,7,8,9,10]
          @json = response[n-1],
              @sequence << response[n-1],
              @kind << response[n-1]["Kind"],
              @carNumber << response[n-1]["CarNumber"],
              @expect << Predict.first.stations[n][:time_arrival2]
        end
        #if overlap
      else #overlap
        @overlap = true
        for n in [1,2,3,4,5,6,7,8,9,10,11]
          @json = response[n-1],
              @sequence << response[n-1]["Sequence"],
              @kind << response[n-1]["Kind"],
              @carNumber << response[n-1]["CarNumber"],
              if n == 1
                @expect << Predict.first.stations[n][:time_arrival2]
              else
                @expect << Predict.first.stations[n-1][:time_arrival2]
              end
        end
      end
    end
  end

  # def apitest
  #   @overlap = false
  #   @json = []
  #   @sequence =  ["","","","","","","","","",""]
  #   @kind =      ["2","","","2","3","3","","","",""]
  #   @carNumber = ["1","","","2","3","4","","","",""]
  #   @expect =    [1,1,1,1,1,1,1,1,1,1]
  # end

  def set_stations
    @stations = {1 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 2 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 3 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 4 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 5 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 6 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 7 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 8 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 9 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 10 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now, time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}}
    }
  end

  def api_test2
    puts "Start"
    response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
    @stations = Predict.first.stations
    for i in (0..response.size-1)
      json = response[i]
      carnumber = json["CarNumber"]
      sequence = json["Sequence"]
      current_status = json["Kind"].to_i
      station = @stations[sequence]
      #Check sequence becuase before_station could be -1
      if sequence == 1
        before_station = @stations[10]
      else
        before_station = @stations[sequence - 1]
      end

      if carnumber.length > 0 and station[:carnumber].length > 0 and station[:carnumber] != carnumber
        check_stop_time(carnumber, station)
        taked_time = calculate_time_taken(carnumber,station, before_station)
        station[:before_car] = station[:carnumber]
        if time_taken != False
          Car.create(carnumber: carnumber, arrived: Time.now, difference: (Time.now - station[:time_stop][station[:before_car]]), sequence: sequence, taked_time: taked_time)
        end
      elsif carnumber.length == 0 and station[:carnumber].length > 0
        station[:before_car] = station[:carnumber]

      elsif carnumber.length >0 and station[:carnumber].length == 0
        check_stop_time(carnumber, station)
        taked_time = calculate_time_taken(carnumber,station, before_station)
        if time_taken != False
          Car.create(carnumber: carnumber, arrived: Time.now, difference: (Time.now - station[:time_stop][station[:before_car]]), sequence: sequence, taked_time: taked_time)
        end
      end
      station[:carnumber] = carnumber
      save_status(station, current_status)
      station[:average_time] = (station[:time_taken].sum / station[:time_taken].size)
    end

    for i in (0..response.size-1)
      json = response[i]
      current_sequence = json["Sequence"]
      current_station = @stations[current_sequence]
      calculated = current_station[:calculated]
      sequences = (1..10).to_a
      pick = 0
      for x in (1..10)
        index = current_sequence - 1 - x
        selected = sequences[index]
        selected_station = @stations[selected]
        if selected_station[:carnumber].length > 0
          pick += 1
          puts "Current_stations: #{current_sequence}"
          puts "nearest_stations: #{selected}"
          puts "status: #{selected_station[:status].to_i}"
          nearest_station = {}
          nearest_station[:sequence] = selected
          nearest_station[:type] = selected_station[:carnumber]
          if pick == 1
            sequence = :sequence
            type = :type
            time_arrival = :time_arrival
            calculation = :calculated
          elsif pick == 2
            sequence = :sequence2
            type = :type2
            time_arrival = :time_arrival2
            calculation = :calculated2
          end
          #Calculated before?
          if calculated[sequence] == nearest_station[:sequence] and calculated[type] != nearest_station[:type]
            total_time = sum_stations(index, current_sequence - 1, sequences, @stations)
            @stations[current_sequence][time_arrival] = Time.now + total_time
            @stations[current_sequence][calculation][sequence] = nearest_station[:sequence]
            @stations[current_sequence][calculation][type] = nearest_station[:type]
          elsif calculated[sequence] != nearest_station[:sequence]
            total_time = sum_stations(index, current_sequence - 1, sequences, @stations)
            @stations[current_sequence][time_arrival] = Time.now + total_time
            @stations[current_sequence][calculation][sequence] = nearest_station[:sequence]
            @stations[current_sequence][calculation][type] = nearest_station[:type]
          end
          puts "calculated[:sequence] : #{calculated[sequence]}"
          puts "total_time: #{total_time}"
          puts "sum_stations: #{index}, #{(current_sequence-1)}, #{sequences} "
          if pick == 2
            break
          end
        else
        end
      end
    end
    Predict.second.update_attributes(stations: @stations)
    puts "end"
  end


end