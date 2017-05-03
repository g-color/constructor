require 'sidekiq/web'

Rails.application.routes.draw do

  resources :primitives
  resources :units
  resources :categories
  resources :composites

  resources :constructor_objects do
    match :info, to: 'constructor_objects#info', as: :info, on: :collection, via: [:get, :post]
    get  :autocomplete_constructor_object_name, on: :collection
  end
  
  resources :products
  resources :clients

  resources :estimates
  post '/estimates/files', to: 'estimates#files', as: :estimates_files


  get  :audits,                       to: 'audits#index',                 as: :audits
  get  :expenses,                     to: 'expenses#index',               as: :expenses
  post :expenses,                     to: 'expenses#update',              as: :expenses_update

  get :reports,                       to: 'reports#index',                as: :reports
  get 'reports/product-popularity',   to: 'reports#product_popularity',   as: :reports_product_popularity
  get 'reports/floor-popularity',     to: 'reports#floor_popularity',     as: :reports_floor_popularity
  get 'reports/area-popularity',      to: 'reports#area_popularity',      as: :reports_area_popularity
  get 'reports/material-consumption', to: 'reports#material_consumption', as: :reports_material_consumption
  get 'reports/estimate-conversion',  to: 'reports#estimate_conversion',  as: :reports_estimate_conversion

  resources :users
  post :find_user_by_name, to: 'users#find_by_name'

  devise_for :users, skip: [:sessions]
  as :user do
    get    'signin',  to: 'devise/sessions#new',     as: :new_user_session
    post   'signin',  to: 'devise/sessions#create',  as: :user_session
    delete 'signout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  mount Sidekiq::Web, at: '/sidekiq'
end
