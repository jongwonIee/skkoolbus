class EstimationsController < ApplicationController
  #건물코드: 국제관0 경영/호암관1 인문/경제관2 법학/수선관3
  def index
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
end
