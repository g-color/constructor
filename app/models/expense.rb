class Expense < ApplicationRecord
  validates :name,    presence: true
  validates :percent, presence: true, numericality: { grater_than_or_equal_to: 0 }

  def self.update_values(values, current_user)
    @current_user = current_user
    values.each do |val|
      expense = find(val)
      expense.percent = values[val]
      next unless expense.changed?

      log_changes(expense)
      expense.save
    end
  end

  def self.total_sum
    sum = 0
    expenses = all
    expenses.each { |exp| sum += exp.percent }
    sum
  end

  def to_s
    name
  end

  def link
    Rails.application.routes.url_helpers.expenses_path
  end

  def self.log_changes(expense)
    Services::Audit::Log.new(
      user:        @current_user,
      action:      Enums::Audit::Action::UPDATE,
      object_type: 'expense',
      object_name: expense.name,
      object_link: expense.link
    ).call
  end
end
