class Expense < ApplicationRecord
  audited

  validates :name,    presence: true
  validates :percent, presence: true, numericality: { grater_than_or_equal_to: 0 }

  def self.update_values(values)
    values.each do |val|
      exp = find(val)
      exp.update(percent: values[val]) unless values[val] == exp.percent.to_s
    end
  end

  def self.total_sum
    sum = 0
    expenses = all
    expenses.each{ |exp| sum += exp.percent }
    sum
  end

  def to_s
    name
  end

  def link
    Rails.application.routes.url_helpers.expenses_path
  end
end
