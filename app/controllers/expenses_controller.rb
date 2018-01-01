class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_ability

  def index
    @expenses = Expense.order(:id).all
    render layout: 'react'
  end

  def update
    Expense.update_values(params[:values], current_user)
    redirect_to expenses_path
  end

  private

  def check_ability
    authorize! :manage, Expense
  end
end
