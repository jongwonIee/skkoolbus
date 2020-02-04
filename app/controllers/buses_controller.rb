class BusesController < ApplicationController
  include BusesHelper
  require 'rubygems'
  require 'mechanize'

  def index

    cookies.delete(:stations)
    reloader
    api
    estimations

  end

  def reloader
    Predict.all
  end

  def api

    # dust
    agent = Mechanize.new
    while
      begin
        content1 = agent.get('https://search.naver.com/search.naver?sm=top_hty&fbm=1&ie=utf8&query=%EC%84%B1%EB%B6%81%EA%B5%AC+%EC%98%A8%EB%8F%84').search("dd.lv1")[0].text
        @dust = '미세먼지 : ' + content1.split('㎥')[1]
        content2 = agent.get('https://search.naver.com/search.naver?sm=top_hty&fbm=1&ie=utf8&query=%EC%84%B1%EB%B6%81%EA%B5%AC+%EC%98%A8%EB%8F%84').search("div.main_info")[0].text
        @temp = content2.gsub('도씨', '').split(',')[0]
        kr_msg = ['행복한 하루 보내세요', '좋은 일이 생길거에요', '오늘은 출첵 안 할지도?', '희망을 가져요', '감기 조심', '할 수 있다', '그럴 수도 있지', ':)']
        en_msg = ['Today is your day', 'Your mountain is waiting, so get on your way', 'No one is perfect, that’s why pencils have erasers', 'You’re braver than you believe']
        msg = kr_msg + en_msg
        @msg = msg.sample()
        raise 'An error has occured.'
        break
      rescue
        break
      end
    end

    # bus tracking
    response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
    # response =  JSON.parse(File.read('app/views/buses/response.json'))
    if response[0]["CarNumber"] == "" and response[1]["CarNumber"] == "" and response[2]["CarNumber"] == "" and response[3]["CarNumber"] == "" and response[4]["CarNumber"] == "" and response[5]["CarNumber"] == "" and response[6]["CarNumber"] == "" and response[7]["CarNumber"] == "" and response[8]["CarNumber"] == "" and response[9]["CarNumber"] == ""
      @on = false
    else
      Rails.logger.info  "WHat's happening"
      @stations = Predict.first.stations.clone
      @on = true
      @json = []
      @kind = []
      @carNumber = []
      @expect = []
      @expect2 = []
      #if no overlap
      if response[10].nil?

        @overlap = false
        for n in [1,2,3,4,5,6,7,8,9,10]
          @json = response[n-1]
          @kind << response[n-1]["Kind"]
          @carNumber << response[n-1]["CarNumber"]
          @expect << Bus.expect(n)
          @expect2 << Bus.expect2(n)
        end
      else #overlap
        @overlap = true

        for n in [1,2,3,4,5,6,7,8,9,10,11]
          @json = response[n-1]
          @kind << response[n-1]["Kind"]
          @carNumber << response[n-1]["CarNumber"]
          if n == 1
            @expect << Bus.expect(n)
            @expect2 << Bus.expect2(n)
          else
            @expect << Bus.expect(n-1)
            @expect2 << Bus.expect2(n-1)
          end
        end
      end
    end
  end

  def set_stations
    @stations = {1 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now.in_time_zone("Asia/Seoul"), time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now.in_time_zone("Asia/Seoul")}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 2 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now.in_time_zone("Asia/Seoul"), time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now.in_time_zone("Asia/Seoul")}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 3 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now.in_time_zone("Asia/Seoul"), time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now.in_time_zone("Asia/Seoul")}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 4 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now.in_time_zone("Asia/Seoul"), time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now.in_time_zone("Asia/Seoul")}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 5 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now.in_time_zone("Asia/Seoul"), time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now.in_time_zone("Asia/Seoul")}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 6 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now.in_time_zone("Asia/Seoul"), time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now.in_time_zone("Asia/Seoul")}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 7 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now.in_time_zone("Asia/Seoul"), time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now.in_time_zone("Asia/Seoul")}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 8 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now.in_time_zone("Asia/Seoul"), time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now.in_time_zone("Asia/Seoul")}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 9 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now.in_time_zone("Asia/Seoul"), time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now.in_time_zone("Asia/Seoul")}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}},
                 10 => {before_car: 0, late: 0, carnumber: '0', time_taken_late: [1], time_taken_late2: [1], time_taken2: [1], existence:0, status: 3, time_depart: Time.now.in_time_zone("Asia/Seoul"), time_taken: [1], average_time: 0, average_time2: 0, time_spent: [1], average_time_spent: 0, time_stop: {"0" => Time.now.in_time_zone("Asia/Seoul")}, time_arrival: 0, time_arrival2: 0, calculated:{sequence: 0, type:0}, calculated2:{sequence2: 0, type2:0}}
    }
  end
end
