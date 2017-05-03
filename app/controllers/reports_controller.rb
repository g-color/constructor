class ReportsController < ApplicationController
  before_action :check_ability

  def index
  end

  def floor_popularity
    @report = {}
    filter_estimates = Estimate.only_signed.date_start(params[:date_start]).date_end(params[:date_end])
    all = filter_estimates.count
    Estimate::FLOOR_NAME.each do |floor, floor_name|
      estimates = filter_estimates.by_floor(floor).count
      @report[floor_name] = all > 0 ? (estimates * 100.0 / all).round : 0
    end
  end

  def area_popularity
    @report = {}
    filter_estimates = Estimate.only_signed.date_start(params[:date_start]).date_end(params[:date_end])
    all = filter_estimates.count
    (Estimate::AREA_MIN..Estimate::AREA_MAX).step(Estimate::AREA_STEP).each do |area|
      estimates = filter_estimates.area_start(area).area_end(area+Estimate::AREA_STEP).count
      @report[area.to_s+'-'+(area+Estimate::AREA_STEP).to_s] = all > 0 ? (estimates * 100.0 / all).round : 0
    end
    estimates = filter_estimates.area_start(Estimate::AREA_MAX + Estimate::AREA_STEP).count
    @report[(Estimate::AREA_MAX+Estimate::AREA_STEP).to_s + '+'] = all > 0 ? (estimates * 100.0 / all).round : 0
  end

  def material_consumption
    Primitive.all.each do |primitive|
      parents = primitive.parent_compositions
    end
  end

  def estimate_conversion
    @report = []
    User.all.each do |user|
      all = user.estimates.count
      signed = user.estimates.only_signed.count
      @report << {
        user_name: user.full_name,
        estimates_all: user.estimates.count,
        estimates_signed: user.estimates.only_signed.count,
        conversion: signed.zero? ? 0 : all / signed,
        profit: user.estimates.only_signed.sum(:price)
        #profit_month: user.estimates.only_signed.sum(:price)
      }
    end

  end

  protected

  def check_ability
    authorize! :view_report, :report
  end

 
end
