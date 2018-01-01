class Modules::Expenses < Grape::API
  resource :expenses do
    desc 'Return a units'
    get do
      Expense.order(:id).all
    end

    desc 'Return a expense'
    params do
      requires :id, type: Integer, desc: 'Expense ID'
    end
    get ':id' do
      Expense.find(params[:id])
    end

    desc 'Update a expense'
    params do
      requires :id,      type: String, desc: 'Expense ID'
      requires :percent, type: String, desc: 'Expense value'
    end
    put ':id' do
      Expense.find(params[:id]).update(percent: params[:percent])
    end
  end
end
