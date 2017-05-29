class Estimate < Budget
  validates :client, presence: true
  validates :name,   uniqueness: {
    scope: :client,
    message: "Название должно быть уникально для клиента",
    case_sensitive: false
  }

  belongs_to :client

  def get_primitives(undivisibilty_objects: false)
    result = {}
    self.stages.each do |stage|
      primitives = stage.get_primitives(undivisibilty_objects: undivisibilty_objects)
      primitives.each do |key, value|
        result[key] = 0 if result[key].nil?
        result[key] += value
      end
    end
    result
  end

  def send_email_engineer(engineer_id)
    EstimateMailer.export_engineer(engineer_id, self.id).deliver_later
  end

  def link
    Rails.application.routes.url_helpers.edit_estimate_path(self)
  end
end
