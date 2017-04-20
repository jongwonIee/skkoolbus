module BusesHelper
#건물코드: 국제관0 경영/호암관1 인문/경제관2 법학/수선관3
#h: 혜화역, m: 맥도날드, j: 정문
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
    @s_walk       = [2,2,2,3]
    @n_walk       = [4,3,3,3]

    #뛰어서
    @h_run        = [9,11,12,13]
    @m_run        = [6,9,10,11]
    @j_run        = [4,6,7,7]
    @s_run        = [1,1,1,2]
    @n_run        = [3,2,2,2]
  end

  def sum_stations(from, to, sequences, stations)
    total_time = 0
    key = :average_time
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
      return false
    end

    if station[:time_taken].size < 3
      station[:time_taken] << time_taken
    else
      station[:time_taken].shift
      station[:time_taken] << time_taken
    end
    return time_taken
  end

  def check_stop_time(carnumber, station)
    station[:time_stop][carnumber]= Time.now.in_time_zone("Asia/Seoul")
  end

  def check_depart_time(station)
    station[:time_depart] = Time.now.in_time_zone("Asia/Seoul")
  end

  def calculate_time_spent(carnumber, station, type)
    time_spent = Time.now.in_time_zone("Asia/Seoul") - station[:time_stop][carnumber]
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
