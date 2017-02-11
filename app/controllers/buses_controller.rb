class BusesController < ApplicationController
  def index
    #gem 이 작동시키도록 수정
    api
    if @carNumber[0] == "" and @carNumber[1] == "" and @carNumber[2] == "" and @carNumber[3] == "" and @carNumber[4] == "" and @carNumber[5] == "" and @carNumber[6] == "" and @carNumber[7] == "" and @carNumber[8] == "" and @carNumber[9] == ""
      redirect_to '/schedule'
    end

    if @overlap
      redirect_to '/overlap'
    end
  end

  def index_overlap
    #gem 이 작동시키도록 수정
    api
    if @carNumber[0] == "" and @carNumber[1] == "" and @carNumber[2] == "" and @carNumber[3] == "" and @carNumber[4] == "" and @carNumber[5] == "" and @carNumber[6] == "" and @carNumber[7] == "" and @carNumber[8] == "" and @carNumber[9] == ""
      redirect_to '/schedule'
    end

    unless @overlap
      redirect_to '/main'
    end
  end

  def api
    #api call - 초단위 갱신
    response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
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
        @sequence << response[n-1]["Sequence"],
        @kind << response[n-1]["Kind"],
        @carNumber << response[n-1]["CarNumber"],
        @expect << Bus.expect(n)
      end
    #if overlap
    else #overlap
      @overlap = true
      for n in [1,2,3,4,5,6,7,8,9,10,11]
        @json = response[n],
        @sequence << response[n]["Sequence"],
        @kind << response[n]["Kind"],
        @carNumber << response[n]["CarNumber"],
        @expect << Bus.expect2(n-1)
      end
    end
  end
end