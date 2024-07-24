module Api
  module V1
    class LocationsController < ApplicationController
      before_action :set_ip_or_url, only: %i[show destroy]
      before_action :set_location, only: %i[show destroy]

      def show
        render(json: LocationSerializer.new(@location), status: :ok)
      end

      def create
        Locations::CreateLocationService.call(params: post_params).with do |success, location, errors|
          if success
            render(json: LocationSerializer.new(location), status: :created)
          else
            render(json: { errors: }, status: :unprocessable_entity)
          end
        end
      end

      def destroy
        Locations::DestroyLocationService.call(location: @location).with do |success, location, errors|
          if success
            render(json: LocationSerializer.new(location), status: :ok)
          else
            render(json: { errors: }, status: :unprocessable_entity)
          end
        end
      end

      private

      def set_ip_or_url
        return @ip = params[:ip_or_url] if Location.address_is_ip?(params[:ip_or_url])
        return @url = params[:ip_or_url] if Location.address_is_url?(params[:ip_or_url])

        render(json: {}, status: :bad_request)
      end

      def set_location
        @location = Location.find_by(ip: @ip) if @ip.present?
        @location = Location.find_by(url: @url) if @url.present?

        return if @location.present?

        render(json: {}, status: :not_found)
      end

      def post_params
        params.permit(:ip, :url)
      end
    end
  end
end
