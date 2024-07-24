class ApplicationController < ActionController::API
  wrap_parameters false

  before_action :authenticate

  def health
    if ActiveRecord::Base.connection.active?
      render json: nil, status: :no_content
    else
      render json: nil, status: :service_unavailable
    end
  end

  private

  def authenticate
    return if authorization.present? && authorization == ENV['SERVICE_ACCESS_KEY']

    render json: nil, status: :unauthorized
  end

  def authorization
    request.headers['Authorization']
  end
end
