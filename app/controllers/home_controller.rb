class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @clients   = current_user.clients.order(updated_at: :desc).limit(5)
    @estimates = current_user.estimates.includes(:client).order(updated_at: :desc).limit(5)
  end
end
