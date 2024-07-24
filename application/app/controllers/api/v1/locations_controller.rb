module Api
  module V1
    class LocationsController < ApplicationController
      before_action :set_address, only: %i[show destroy]
      before_action :set_location, only: %i[show destroy]

      def index
        @locations = Location.filter_by(filter_params)
        @locations_per_page = @locations.page(params[:page])
        render(json: LocationSerializer.new(@locations_per_page, {
          meta: {
            total_pages: @locations_per_page.total_pages,
            records: @locations.count,
            current_page: @locations_per_page.current_page
          }
        }), status: :ok)
      end

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

      def set_address
        return @ip = params[:address] if Location.address_is_ip?(params[:address])
        return @url = params[:address] if Location.address_is_url?(params[:address])

        render(json: {}, status: :bad_request)
      end

      def set_location
        @location = Location.from_ip(@ip).current if @ip.present?
        @location = Location.from_url(@url).current if @url.present?

        return if @location.present?

        render(json: {}, status: :not_found)
      end

      def post_params
        params.permit(:ip, :url)
      end

      def filter_params
        params.permit(:ip, :url)
      end
    end
  end
end
