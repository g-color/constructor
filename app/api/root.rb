class Root < Grape::API
  format :json

  mount Modules::Categories
  mount Modules::Units

  add_swagger_documentation(mount_path: '/doc', markdown: true)
end
