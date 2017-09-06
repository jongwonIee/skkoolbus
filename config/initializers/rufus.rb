include BusesHelper

Rails.logger.info "Start_process"
scheduler = Rufus::Scheduler.singleton
iii = 0
unless defined?(Rails::Console) || File.split($0).last == 'rake'
scheduler.every '5s' do
  iii += 1
  Rails.logger.info "Startssss2"
  Rails.logger.info "new_#{iii}"
  Car.create(carnumber: 0)
  response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
  @stations = Predict.first.stations
  for i in (0..response.size-1)
  Rails.logger.info "selecting_response#{i}"
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
      Rails.logger.info "Check Stop time, carnumber:#{carnumber}"
      check_stop_time(carnumber, station)
      Rails.logger.info "Stop time: #{station[:time_stop][carnumber]}"
      Rails.logger.info "@station : #{@stations[sequence][:time_stop][carnumber]}"
      time_taken = calculate_time_taken(carnumber,station, before_station)
      station[:before_car] = station[:carnumber]
      if time_taken != false
        Car.create(carnumber: carnumber, arrived: Time.now.in_time_zone("Asia/Seoul"), difference: (Time.now.in_time_zone("Asia/Seoul") - station[:time_stop][station[:before_car]]), sequence: sequence, time_taken: time_taken)
      end
    elsif carnumber.length == 0 and station[:carnumber].length > 0
      Rails.logger.info "Car is gone"
      station[:before_car] = station[:carnumber]

    elsif carnumber.length >0 and station[:carnumber].length == 0
      Rails.logger.info "Check Stop time, carnumber:#{carnumber}"
      check_stop_time(carnumber, station)
      Rails.logger.info "Stop time: #{station[:time_stop][carnumber]}"
      Rails.logger.info "@station : #{@stations[sequence][:time_stop][carnumber]}"
      time_taken = calculate_time_taken(carnumber,station, before_station)
      if time_taken != false
        Car.create(carnumber: carnumber, arrived: Time.now.in_time_zone("Asia/Seoul"), difference: (Time.now.in_time_zone("Asia/Seoul") - station[:time_stop][station[:before_car]]), sequence: sequence, time_taken: time_taken)
      end
    end
    station[:carnumber] = carnumber
    save_status(station, current_status)
    station[:average_time] = (station[:time_taken].sum / station[:time_taken].size)
  Rails.logger.info "selecting_response_end"
  end

  Rails.logger.info "Start_calculation"
  for i in (0..response.size-1)
  Rails.logger.info "selecting#{i}"
    json = response[i]
    current_sequence = json["Sequence"]
    current_station = @stations[current_sequence]
    calculated = current_station[:calculated]
    sequences = (1..10).to_a
    pick = 0
    for x in (1..10)
      index = current_sequence - 1 - x
      selected = sequences[index]
      selected_next = sequences[index+1]
      selected_station = @stations[selected]
      Rails.logger.info "Selecting"
      if selected_station[:carnumber].length > 0
	Rails.logger.info"Selected #{selected}"
        pick += 1
        puts "Current_stations: #{current_sequence}"
        puts "nearest_stations: #{selected}"
        puts "status: #{selected_station[:status].to_i}"
        nearest_station = {}
        current_nth = (current_sequence - selected).abs
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
          total_time = sum_stations(index, current_sequence - 1, sequences, @stations)
        if calculated[sequence] == nearest_station[:sequence] and calculated[type] != nearest_station[:type]
	Rails.logger.info "calculated"
          @stations[current_sequence][time_arrival] = Time.now.in_time_zone("Asia/Seoul") + total_time
          @stations[current_sequence][calculation][sequence] = nearest_station[:sequence]
          @stations[current_sequence][calculation][type] = nearest_station[:type]
	Rails.logger.info "calculated_end"
        elsif calculated[sequence] != nearest_station[:sequence]
	Rails.logger.info "calculated"
          #total_time = sum_stations(index, current_sequence - 1, sequences, @stations)
          @stations[current_sequence][time_arrival] = Time.now.in_time_zone("Asia/Seoul") + total_time
          @stations[current_sequence][calculation][sequence] = nearest_station[:sequence]
          @stations[current_sequence][calculation][type] = nearest_station[:type]
	Rails.logger.info "calculated_end"
        end
	Rails.logger.info "next_step_after_calculate"
        left_time = @stations[current_sequence][time_arrival] - Time.now.in_time_zone("Asia/Seoul")
	Rails.logger.info "What?"
        taking_time = total_time - @stations[selected_next][:average_time]
	Rails.logger.info "Left_time:#{left_time}, taking_time:#{taking_time} "
	Rails.logger.info "current_nth: #{current_nth}"
        if current_nth != 1 and left_time < taking_time
          @stations[current_sequence][time_arrival] = Time.now.in_time_zone("Asia/Seoul") + taking_time
	  Rails.logger.info "Current_station: #{current_sequence}, taking_time: #{taking_time}"
	  Rails.logger.info "@stations[#{current_sequence}][time_arrival] = #{Time.now.in_time_zone("Asia/Seoul")+taking_time}"
        end
        puts "calculated[:sequence] : #{calculated[sequence]}"
        puts "sum_stations: #{index}, #{(current_sequence-1)}, #{sequences} "
        if pick == 2
          break
        end
      else
      end
    end
  end
  Rails.logger.info "Let's Update"
  Predict.first.update_attributes(stations: @stations)
  Rails.logger.info "end"
end
end
