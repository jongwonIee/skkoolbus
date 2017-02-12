class BusesController < ApplicationController
  def index
    if @overlap
      redirect_to '/overlap'
    else
      #gem 이 작동시키도록 수정
      apitest
    end
  end

  def index_overlap
    if !@overlap
      redirect_to '/main'
    else
      #gem 이 작동시키도록 수정
      apitest
    end
  end

  def api
    #api call - 초단위 갱신
    response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
    if response[2]["CarNumber"] == "" and response[3]["CarNumber"] == "" and response[4]["CarNumber"] == "" and response[5]["CarNumber"] == "" and response[6]["CarNumber"] == "" and response[7]["CarNumber"] == "" and response[8]["CarNumber"] == "" and response[9]["CarNumber"] == ""
      redirect_to '/schedule'
    else
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
          if n == 1
            @expect << Bus.expect2(1)
          else
            @expect << Bus.expect2(n-1)
          end
        end
      end
    end
  end

  def apitest
    @overlap = false
    @json = []
    @sequence =  ["","","","","","","","","",""]
    @kind =      ["2","","","2","3","3","","","",""]
    @carNumber = ["1","","","2","3","4","","","",""]
    @expect =    [1,1,1,1,1,1,1,1,1,1]
  end
end