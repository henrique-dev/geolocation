module Locations
  class DestroyLocationService < ApplicationService
    def call(location:)
      with_service_handler do
        destroy_location(location)
      end
    end

    private

    def destroy_location(location)
      location.destroy!
    rescue
      raise Errors::ServiceError.new(errors: { location: ['could not destroy the location'] })
    end
  end
end
