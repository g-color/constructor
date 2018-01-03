class Modules::Categories < Grape::API
  resource :categories do
    desc 'Return a categories'
    get do
      Category.order(:id).all
    end

    desc 'Return a category'
    params do
      requires :id, type: Integer, desc: 'Category ID'
    end
    get ':id' do
      Category.find(params[:id])
    end

    desc 'Create a category'
    params do
      requires :name, type: String, desc: 'Category name'
      requires :product, type: Boolean, desc: 'Category type'
    end
    post do
      category = Category.new(
        name:    params[:name],
        product: params[:product]
      )
      category.save
      category.errors if category.errors.present?
    end

    desc 'Update a category'
    params do
      requires :id, type: String, desc: 'Category ID'
      requires :name, type: String, desc: 'Category name'
      requires :product, type: Boolean, desc: 'Category type'
    end
    put ':id' do
      category = Category.find(params[:id])
      category.update(
        name:    params[:name],
        product: params[:product]
      )
      category.errors if category.errors.present?
    end

    desc 'Delete a category'
    params do
      requires :id, type: String, desc: 'Category ID'
    end
    delete ':id' do
      Category.find(params[:id]).destroy
    end
  end
end
