class Solution < Budget
  acts_as_paranoid
  audited

  scope :accepted, -> { where(proposed: false)}
  scope :proposed, -> { where(proposed: true) }

  def link
    Rails.application.routes.url_helpers.edit_solution_path(self)
  end
end
