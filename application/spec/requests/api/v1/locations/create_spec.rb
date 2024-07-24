require 'swagger_helper'

RSpec.describe '/api/v1/locations', type: :request, vcr: { match_requests_on: %i[host path] } do
  let(:location_params) { {} }
  let(:Authorization) { ENV['SERVICE_ACCESS_KEY'] }

  path '/api/v1/locations' do
    post 'Create a location' do
      tags 'Locations'

      consumes 'application/json'
      produces 'application/json'

      security [ApiKeyAuth: []]

      parameter name: :location_params, in: :body, schema: {
        type: :object,
        properties: {
          ip: { type: :string },
          url: { type: :string }
        },
        required: %i[]
      }

      context 'with valid arguments' do
        response '201', 'location created' do
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
                          url: { type: :string, nullable: true },
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
                          location: { type: :object, nullable: true },
                          time_zone: { type: :object, nullable: true },
                          currency: { type: :object, nullable: true },
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
            let(:location_params) { { ip: '134.201.250.155' } }

            run_test!
          end

          context 'with an url as address' do
            let(:location_params) { { url: 'www.positrace.com' } }

            run_test!
          end
        end
      end

      context 'with invalid arguments' do
        response '401', 'not authorized' do
          let(:Authorization) { 'invalid-token' }

          run_test!
        end

        response '422', 'unprocessable entity without ip and url' do
          schema type: :object,
              properties: {
                errors: {
                  type: :object,
                  properties: {
                    address: { type: :array, items: { type: :string } }
                  },
                  required: %i[address]
                }
              },
              required: %i[errors]

          run_test!
        end

        response '422', 'unprocessable entity with an invalid ip' do
          schema type: :object,
              properties: {
                errors: {
                  type: :object,
                  properties: {
                    ip: { type: :array, items: { type: :string } }
                  },
                  required: %i[ip]
                }
              },
              required: %i[errors]

          let(:location_params) { { ip: 'invalid-ip' } }

          run_test!
        end

        response '422', 'unprocessable entity with an invalid url' do
          schema type: :object,
              properties: {
                errors: {
                  type: :object,
                  properties: {
                    url: { type: :array, items: { type: :string } }
                  },
                  required: %i[url]
                }
              },
              required: %i[errors]

          let(:location_params) { { url: 'url.with space' } }

          run_test!
        end
      end
    end
  end
end
