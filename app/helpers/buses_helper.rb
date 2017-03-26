module BusesHelper
  #건물코드: 국제관0 경영/호암관1 인문/경제관2 법학/수선관3  
    def estimations
          #마을버스 혜화역 -> 각 건물
      #1교시 (8시, 9시)
    if Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "08" or Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "09"
      @h_maeul      = [6,7,7,7]
      @h_maeul_walk = [2,4,5,7]
      #2교시 (10시, 11시)
    elsif Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "10" or Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "11"
      @h_maeul      = [5,6,6,6]
      @h_maeul_walk = [2,4,5,7]
      #나머지시간
    else
      @h_maeul      = [4,5,5,5]
      @h_maeul_walk = [2,4,5,7]
    end

    #택시 혜화역 -> 각 건물
      #1교시 (8시, 9시)
    if Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "08" or Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "09"
      @h_taxi       = [12,14,14,15]
      #2교시 (10시, 11시)
    elsif Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "10" or Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "11"
      @h_taxi       = [10,12,12,13]
      #나머지시간
    else
      @h_taxi       = [9,11,11,12]
    end
    #택시 맥도날드 -> 각 건물
      #1교시 (8시, 9시)
    if Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "08" or Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "09"
      @m_taxi       = [6,8,8,9]
      #2교시 (10시, 11시)
    elsif Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "10" or Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "11"
      @m_taxi       = [5,7,7,8]
      #나머지시간
    else
      @m_taxi       = [6,8,8,9]
    end
    #이하 시간무관
    #택시 정문 -> 각 건물
      @j_taxi       = [3,5,5,6]

    #걸어서
      @h_walk       = [11,14,15,17]
      @m_walk       = [8,11,12,14]
      @j_walk       = [5,8,9,12]

    #뛰어서
      @h_run        = [9,11,12,13]
      @m_run        = [6,9,10,11]
      @j_run        = [4,6,7,7]

    #셔틀역 -> 각 건물 (도보)
      @shuttle_walk = [2,2,2,1]
    end







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

    def calculate_time_taken(carnumber,station, before_station, type, late)
      if type == 1
        time_taken = Time.now - before_station[:time_depart]
        if late == 0
          key = :time_taken
        elsif late == 1
          key = :time_taken_late
        end
        if station[key].size < 3
          station[key] << time_taken
        else
          station[key].shift
          station[key] << time_taken
        end
      elsif type == 2
        @time_stop = station[:time_stop][carnumber]
        @before_stop = before_station[:time_stop][carnumber]
        if @time_stop != nil and @before_stop != nil
          time_taken = station[:time_stop][carnumber] - before_station[:time_stop][carnumber]
        else
          time_taken = 1
        end
        if late == 0
          key = :time_taken2
        elsif late == 1
          key = :time_taken_late2
        end
        if station[key].size < 3
          station[key] << time_taken
        else
          station[key].shift
          station[key] << time_taken
        end
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
