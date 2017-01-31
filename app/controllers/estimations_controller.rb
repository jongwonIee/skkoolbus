class EstimationsController < ApplicationController
  def index
    @maeul_global_walk = 2
    #1 교시  (8시, 9시)
    if Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "08" or Time.now.in_time_zone("Asia/Seoul").strftime("%I") == "09"
      @maeul_global = 7
      @maeul_others = 8
      # elsif
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
