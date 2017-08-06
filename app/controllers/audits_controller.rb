class AuditsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_ability

  def index
    @audits = Audit.all

    if search? || date_filter?
      if params[:search]['user_id'].present?
        user = User.find(params[:search]['user_id'])
        @audits = @audits.where(user_name: user.full_name)
      end
      if params[:search]['object_type'].present?
        @audits = @audits.where(object_type: params[:search]['object_type'])
      end

      @audits = @audits.where('created_at >= ?', params[:from]) if params[:from].present?
      @audits = @audits.where('created_at <= ?', params[:till]) if params[:till].present?
    end

    @audits = @audits.order(created_at: :desc)

    respond_to do |format|
      format.html
      format.csv { send_data @audits.to_csv, filename: "audits-#{Date.today}.csv" }
      format.xls
    end
  end

  protected

  def check_ability
    authorize! :manage, Audit
  end

  def search?
    search = false
    if params[:search].present?
      params[:search].each do |val|
        search = true unless val.blank?
      end
    end
    search
  end

  def date_filter?
    params[:from].present? || params[:till].present?
  end
end
