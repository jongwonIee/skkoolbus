class EstimationsController < ApplicationController
  def index
    #1교시 (8시, 9시)
    if Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "08" or Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "09"
      @maeul_bus  = [7,8,8,8,8,8,8]
      @maeul_walk = [2,4,5,5,5,7,7]
    #2교시 (10시, 11시)
    elsif Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "10" or Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "11"
      @maeul_bus  = [7,8,8,8,8,8,8]
      @maeul_walk = [2,4,5,5,5,7,7]
    #나머지
    else
      @maeul_bus  = [7,8,8,8,8,8,8]
      @maeul_walk = [2,4,5,5,5,7,7]
    end


    #도보
    #경영/호암 1
    # @maeul_gh_b =
    # #경제/인문 1
    # @maeul_gi_b =
    # #수선/법학 1
    # @maeul_sb_ =
    # #국제관 1
    # @maeul_g =
  end
end
