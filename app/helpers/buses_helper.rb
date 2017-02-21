module BusesHelper
  def sum_stations(from, to, sequences, stations, type)
    total_time = 0
    if from < 0
      for between in sequences[10+from, 9]
        total_time += stations[between][:average_time]
      end
      for between in sequences[0, to]
        total_time += stations[between][:average_time]
      end
    else
      for between in sequences[from, to]
        total_time += stations[between][:average_time]
      end
    end
    if type == 2
      total_time += stations[sequences[from]][:average_time_spent]
    end
    return total_time
  end
end
