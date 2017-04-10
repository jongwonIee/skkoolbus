include BusesHelper

Rails.logger.info "Start_process"
scheduler = Rufus::Scheduler.singleton
i = 0
scheduler.every '5s' do
  i += 1
  Rails.logger.info "Startssss"
  Rails.logger.info i
  Car.create(carnumber: 0)
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
      time_taken = calculate_time_taken(carnumber,station, before_station)
      station[:before_car] = station[:carnumber]
      if time_taken != false
        Car.create(carnumber: carnumber, arrived: Time.now.in_time_zone("Asia/Seoul"), difference: (Time.now.in_time_zone("Asia/Seoul") - station[:time_stop][station[:before_car]]), sequence: sequence, time_taken: time_taken)
      end
    elsif carnumber.length == 0 and station[:carnumber].length > 0
      station[:before_car] = station[:carnumber]

    elsif carnumber.length >0 and station[:carnumber].length == 0
      check_stop_time(carnumber, station)
      time_taken = calculate_time_taken(carnumber,station, before_station)
      if time_taken != false
        Car.create(carnumber: carnumber, arrived: Time.now.in_time_zone("Asia/Seoul"), difference: (Time.now.in_time_zone("Asia/Seoul") - station[:time_stop][station[:before_car]]), sequence: sequence, time_taken: time_taken)
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
          @stations[current_sequence][time_arrival] = Time.now.in_time_zone("Asia/Seoul") + total_time
          @stations[current_sequence][calculation][sequence] = nearest_station[:sequence]
          @stations[current_sequence][calculation][type] = nearest_station[:type]
        elsif calculated[sequence] != nearest_station[:sequence]
          total_time = sum_stations(index, current_sequence - 1, sequences, @stations)
          @stations[current_sequence][time_arrival] = Time.now.in_time_zone("Asia/Seoul") + total_time
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
  Predict.first.update_attributes(stations: @stations)
  puts "end"
end