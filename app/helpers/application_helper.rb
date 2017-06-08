module ApplicationHelper
  def money(value)
    value.round.to_s(:delimited, delimiter: ' ')
  end

  def with_presicion(value)
    return value.to_i if value == value.to_i
    value
  end
end
