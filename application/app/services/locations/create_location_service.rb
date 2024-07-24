module Locations
  class CreateLocationService < ApplicationService
    def call(params:)
      with_service_handler do
        contract = Locations::NewLocationContract.call(params.to_h)

        create_location(contract)
      end
    end

    private

    def create_location(params)
      service_response = Providers::IpStack::FillLocationService.call(
        location: Location.new, ip_or_url: params[:ip] || params[:url]
      )

      if service_response.success
        location = service_response.object

        return location if location.save
      end

      raise Errors::ServiceError.new(errors: { location: ['could not create the location'] })
    end
  end
end
