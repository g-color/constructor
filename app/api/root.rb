class Root < Grape::API
  prefix :api
  format :json

  before do
    error!('401 Unauthorized', 401) unless authenticated
  end

  helpers do
    def warden
      env['warden']
    end

    def authenticated
      warden.authenticated?
    end

    def current_user
      warden.user
    end
  end

  mount Modules::Categories
  mount Modules::Units
  mount Modules::Expenses

  add_swagger_documentation(mount_path: '/doc', markdown: true)
end
