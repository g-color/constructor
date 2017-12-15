class Constructor::Category < Grape::API
  resource :categories do
    desc 'Return a category.'
    params do
      requires :id, type: Integer, desc: 'Category id.'
    end
    route_param :id do
      get do
        ::Category.find(params[:id])
      end
    end

    desc 'Create a status.'
    params do
      requires :status, type: String, desc: 'Your status.'
    end
    post do
      authenticate!
      Status.create!({
        user: current_user,
        text: params[:status]
      })
    end

    desc 'Update a status.'
    params do
      requires :id, type: String, desc: 'Status ID.'
      requires :status, type: String, desc: 'Your status.'
    end
    put ':id' do
      authenticate!
      current_user.statuses.find(params[:id]).update({
        user: current_user,
        text: params[:status]
      })
    end

    desc 'Delete a status.'
    params do
      requires :id, type: String, desc: 'Status ID.'
    end
    delete ':id' do
      authenticate!
      current_user.statuses.find(params[:id]).destroy
    end


  end
end
