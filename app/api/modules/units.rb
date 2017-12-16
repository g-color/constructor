class Modules::Units < Grape::API
  resource :units do
    desc 'Return a units'
    get do
      Unit.all
    end

    desc 'Return a unit'
    params do
      requires :id, type: Integer, desc: 'Unit ID'
    end
    get ':id' do
      Unit.find(params[:id])
    end

    desc 'Create a unit'
    params do
      requires :name, type: String, desc: 'Unit name'
    end
    post do
      authenticate!
      Unit.create!(name: params[:name])
    end

    desc 'Update a unit'
    params do
      requires :id, type: String, desc: 'Unit ID'
      requires :name, type: String, desc: 'Unit name'
    end
    put ':id' do
      authenticate!
      Unit.find(params[:id]).update(name: params[:name])
    end

    desc 'Delete a unit'
    params do
      requires :id, type: String, desc: 'Unit ID'
    end
    delete ':id' do
      authenticate!
      Unit.find(params[:id]).destroy
    end
  end
end
