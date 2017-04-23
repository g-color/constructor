class PriceUpdateJob < ActiveJob::Base
  queue_as :update_price

  def perform(obj)
    obj.update_price
  end
end
