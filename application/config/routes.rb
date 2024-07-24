Rails.application.routes.draw do
  get '/health', to: 'application#health'

  unless Rails.env.production?
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
  end

  namespace :api do
    namespace :v1 do
      resources :locations, param: :address, constraints: { address: /.*/ }
    end
  end
end
