module Locations
  module Providers
    module IpStack
      class DataProvider
        include HTTParty

        base_uri 'api.ipstack.com'

        def initialize
          @options = { query: { access_key: ENV['IP_STACK_ACCESS_KEY'] } }
        end

        def location(ip_or_url)
          self.class.get("/#{ip_or_url}", @options)
        rescue StandardError
          raise Errors::ServiceError.new(errors: { provider: ['unable to establish the connection'] })
        end
      end

      class FillLocationService < ApplicationService
        def call(location:, ip_or_url:)
          with_service_handler do
            response = DataProvider.new.location(ip_or_url)

            raise Errors::ServiceError.new(errors: { provider: ['the data provided is not valid'] }) unless response.ok?

            assign_location_attributes(location, ip_or_url, response.parsed_response)

            location
          end
        end

        private

        def assign_location_attributes(location, ip_or_url, params)
          location.assign_attributes({
            ip: params['ip'], url: (!(ip_or_url =~ Resolv::AddressRegex).nil? ? nil : ip_or_url),
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
