class Estimate < Budget
  belongs_to :client
  validates  :client, presence: true

  def link
    Rails.application.routes.url_helpers.edit_estimate_path(self)
  end

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
    puts "\n\n\n\n", engineer_id, "\n\n\n"
  end
end
