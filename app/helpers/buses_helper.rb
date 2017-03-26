module BusesHelper
  def sum_stations(from, to, sequences, stations, type, version)
    total_time = 0
    if version == 1
      key = :average_time
    elsif version == 2
      key = :average_time2
    end
    if from < -1
      for between in sequences[11+from .. 9]
        total_time += stations[between][key]
      end
      for between in sequences[0 .. to]
        total_time += stations[between][key]
      end
    else
      for between in sequences[from+1 .. to]
        total_time += stations[between][key]
      end
    end
    if type == 2
      total_time += stations[sequences[from]][:average_time_spent]
    end
    return total_time
  end

  def calculate_time_taken(carnumber,station, before_station)
      @time_stop = station[:time_stop][carnumber]
      @before_stop = before_station[:time_stop][carnumber]
      if @time_stop != nil and @before_stop != nil 
        time_taken = station[:time_stop][carnumber] - before_station[:time_stop][carnumber]
      else 
        time_taken = 1
      end

      if time_taken > 1800 
        return False
      end

      if station[key].size < 3
        station[key] << time_taken
      else
        station[key].shift
        station[key] << time_taken
      end
    return time_taken
  end

  def check_stop_time(carnumber, station)
    if Time.now - station[:time_stop][carnumber] > 800
      station[:time_stop][carnumber]= Time.now
    end
  end

  def check_depart_time(station)
    station[:time_depart] = Time.now
  end

  def calculate_time_spent(carnumber, station, type)
    time_spent = Time.now - station[:time_stop][carnumber]
    if type == "nonstop"
      input_time_spent(station, 0)
    elsif type == "stop"
      input_time_spent(station, time_spent)
    end
  end

  def input_time_spent(station, time_spent)
      if station[:time_spent].size < 3
        station[:time_spent] << time_spent 
      else
        station[:time_spent].shift
        station[:time_spent] << time_spent 
      end
  end

  def change_existence(station, value)
    station[:existence] = value
  end

  def save_status(station, status)
    station[:status] = status
  end
end
