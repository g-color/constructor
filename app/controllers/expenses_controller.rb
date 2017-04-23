class ExpensesController < ApplicationController
  before_action :check_ability

  def index
    @expenses = Expense.order(:id).all
  end

  def update
    Expense.update_values(params[:values])
    redirect_to expenses_path
  end

  private

  def check_ability
    authorize! :manage, Expense
  end
end
