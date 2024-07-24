require 'swagger_helper'

RSpec.describe '/api/v1/locations/{address}', type: :request do
  let(:location) { create(:location, created_at: DateTime.now) }
  let(:address) { location.ip }
  let(:Authorization) { ENV['SERVICE_ACCESS_KEY'] }

  before do
    create(:location, ip: location.ip, url: location.url, created_at: DateTime.now - 10.days)
    create(:location, ip: location.ip, url: location.url, created_at: DateTime.now - 20.days)
  end

  path '/api/v1/locations/{address}' do
    get 'Retrieve the last location' do
      tags 'Locations'

      produces 'application/json'

      security [ApiKeyAuth: []]

      parameter name: :address, in: :path, type: :string

      context 'with valid arguments' do
        response '200', 'location found' do
          schema type: :object,
                properties: {
                  data: {
                    type: :object,
                    properties: {
                      id: { type: :string },
                      type: { type: :string },
                      attributes: {
                        type: :object,
                        properties: {
                          ip: { type: :string },
                          url: { type: :string },
                          kind: { type: :string },
                          continent_code: { type: :string },
                          continent_name: { type: :string },
                          country_code: { type: :string },
                          country_name: { type: :string },
                          region_code: { type: :string },
                          region_name: { type: :string },
                          city: { type: :string },
                          zip: { type: :string },
                          latitude: { type: :string },
                          longitude: { type: :string },
                          location: { type: :object },
                          time_zone: { type: :object },
                          currency: { type: :object },
                          created_at: { type: :string },
                          updated_at: { type: :string }
                        },
                        required: %i[ip url kind continent_code continent_name country_code country_name region_code
                                     region_name city zip latitude longitude location time_zone currency created_at
                                     updated_at]
                      }
                    },
                    required: %i[id type attributes]
                  }
                },
                required: %i[data]

          context 'with an ip as address' do
            let(:address) { location.ip }

            run_test! do |response|
              data = JSON.parse(response.body)
              expect(data['data']['id']).to eq(location.id)
            end
          end

          context 'with an url as address' do
            let(:address) { location.url }

            run_test! do |response|
              data = JSON.parse(response.body)
              expect(data['data']['id']).to eq(location.id)
            end
          end
        end
      end

      context 'with invalid arguments' do
        response '401', 'not authorized' do
          let(:Authorization) { 'invalid-token' }

          run_test!
        end

        response '404', 'not found' do
          let(:address) { ['255.255.255.255', 'domain.not.created.com'].sample }

          run_test!
        end
      end
    end
  end
end
