Rails.application.routes.draw do
  get '/health', to: 'application#health'

  unless Rails.env.production?
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
  end
end
