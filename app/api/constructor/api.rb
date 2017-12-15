class Constructor::Api < Grape::API
  format :json

  mount Constructor::Category

  add_swagger_documentation(mount_path: '/swagger_doc', markdown: true)
end
