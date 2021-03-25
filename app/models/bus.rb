class Bus < ApplicationRecord

  def self.generate
    @array = []
    @limit = [4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0]
    @stations = Predict.first.stations
    [1,2,3,4,5,6,7,8,9,10].each do |i|
      average = @stations[i][:average_time]
      if (average / 60) < @limit[i-1]
        @array << (average / 60)
      else
        @array << @limit[i-1]
      end
    end
    return @array
  end

  def self.expect(n)
    Bus.generate
    response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
    # response = JSON.parse(File.read('app/views/buses/response.json'))
    if response.length == 11
      response = response.drop(1)
    end
    count = 0
    for l in 1..10
      if response[n-1-l]["CarNumber"].empty?
        count += 1
      else
        break
      end
    end
    result = 0
    for i in n-2-count..n-2
      result += @array[i]
    end
    return result
  end

  def self.expect2(n)
    Bus.generate
    response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
    # response = JSON.parse(File.read('app/views/buses/response.json'))
    if response.length == 11
      response = response.drop(1)
    end
    count = 0
    token = 0
    for l in 1..10
      if response[n-1-l]["CarNumber"].empty?
        count += 1
      elsif !response[n-1-l]["CarNumber"].empty? && token == 0
        count += 1
        token += 1
      elsif (token == 1) and (response[n-1-l]["CarNumber"].empty?)
        break
      end
    end
    result = 0
    for i in n-2-count..n-2
      result += @array[i]
    end
    return result
  end

  def self.time(n)

    Bus.generate

    result = 0

    if n == 5 or n == 6 or n == 7 or n == 8 or n == 9
      (n..9).each do |i|
        result += @array[i].to_i
      end
    else
      (n..4).each do |i|
        result += @array[i].to_i
      end
    end
    return result.to_i
  end
end