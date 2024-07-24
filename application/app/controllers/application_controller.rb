class ApplicationController < ActionController::API
  def health
    if ActiveRecord::Base.connection.active?
      render json: nil, status: :no_content
    else
      render json: nil, status: :service_unavailable
    end
  end
end
