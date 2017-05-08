module ApplicationHelper
  def money(value)
    value.round.to_s(:delimited, delimiter: ' ')
  end
end
