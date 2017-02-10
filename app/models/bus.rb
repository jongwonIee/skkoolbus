class Bus < ApplicationRecord

  def self.expect(n)

    @array = [
        ((Bus.find(1).s1 + Bus.find(2).s1 + Bus.find(3).s1) / 3),
        ((Bus.find(1).s2 + Bus.find(2).s2 + Bus.find(3).s2) / 3),
        ((Bus.find(1).s3 + Bus.find(2).s3 + Bus.find(3).s3) / 3),
        ((Bus.find(1).s4 + Bus.find(2).s4 + Bus.find(3).s4) / 3),
        ((Bus.find(1).s5 + Bus.find(2).s5 + Bus.find(3).s5) / 3),
        ((Bus.find(1).s6 + Bus.find(2).s6 + Bus.find(3).s6) / 3),
        ((Bus.find(1).s7 + Bus.find(2).s7 + Bus.find(3).s7) / 3),
        ((Bus.find(1).s8 + Bus.find(2).s8 + Bus.find(3).s8) / 3),
        ((Bus.find(1).s9 + Bus.find(2).s9 + Bus.find(3).s9) / 3),
        ((Bus.find(1).s10 + Bus.find(2).s10 + Bus.find(3).s10) / 3)
    ]

    response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
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

  #overlap
  def self.expect2(n)

    @array = [
        ((Bus.find(1).s1 + Bus.find(2).s1 + Bus.find(3).s1) / 3),
        ((Bus.find(1).s1 + Bus.find(2).s1 + Bus.find(3).s1) / 3),
        ((Bus.find(1).s2 + Bus.find(2).s2 + Bus.find(3).s2) / 3),
        ((Bus.find(1).s3 + Bus.find(2).s3 + Bus.find(3).s3) / 3),
        ((Bus.find(1).s4 + Bus.find(2).s4 + Bus.find(3).s4) / 3),
        ((Bus.find(1).s5 + Bus.find(2).s5 + Bus.find(3).s5) / 3),
        ((Bus.find(1).s6 + Bus.find(2).s6 + Bus.find(3).s6) / 3),
        ((Bus.find(1).s7 + Bus.find(2).s7 + Bus.find(3).s7) / 3),
        ((Bus.find(1).s8 + Bus.find(2).s8 + Bus.find(3).s8) / 3),
        ((Bus.find(1).s9 + Bus.find(2).s9 + Bus.find(3).s9) / 3),
        ((Bus.find(1).s10 + Bus.find(2).s10 + Bus.find(3).s10) / 3)
    ]

    response = JSON.parse(HTTParty.get "http://scard.skku.edu/Symtra_Bus/BusLocationJson.asp")
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
end