module Locations
  module Providers
    module IpStack
      class DataProvider
        include HTTParty

        base_uri 'api.ipstack.com'

        def initialize
          @options = { query: { access_key: ENV['IP_STACK_ACCESS_KEY'], headers: { 'Content-Type' => 'application/json' } } }
        end

        def location(address)
          response = self.class.get("/#{address}", @options)

          return response unless response.parsed_response[:error].present?

          # TODO: send the error for an error tracking application
          raise Errors::ServiceError.new(errors: { provider: ['did not process the request'] })
        rescue StandardError
          raise Errors::ServiceError.new(errors: { provider: ['unable to establish the connection'] })
        end
      end

      class FillLocationService < ApplicationService
        def call(location:, address:)
          with_service_handler do
            response = DataProvider.new.location(address)

            raise Errors::ServiceError.new(errors: { provider: ['the data provided is not valid'] }) unless response.ok?

            assign_location_attributes(location, address, response.parsed_response)

            location
          end
        end

        private

        def assign_location_attributes(location, address, params)
          location.assign_attributes({
            ip: params['ip'], url: (!(address =~ Resolv::AddressRegex).nil? ? nil : address),
            kind: params['type'], continent_code: params['continent_code'],
            continent_name: params['continent_name'], country_code: params['country_code'],
            country_name: params['country_name'], region_code: params['region_code'],
            region_name: params['region_name'], city: params['city'],
            zip: params['zip'], latitude: params['latitude'],
            longitude: params['longitude'], location: params['location'],
            time_zone: params['time_zone'], currency: params['currency']
          })
        end
      end
    end
  end
end
