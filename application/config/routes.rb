Rails.application.routes.draw do
  get '/health', to: 'application#health'

  unless Rails.env.production?
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
  end

  namespace :api do
    namespace :v1 do
      resources :locations, param: :ip_or_url, constraints: { ip_or_url: /.*/ }, only: %i[show create destroy]
    end
  end
end
