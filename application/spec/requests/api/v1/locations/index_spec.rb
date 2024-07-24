require 'swagger_helper'

RSpec.describe '/api/v1/locations', type: :request do
  let(:ip) { nil }
  let(:url) { nil }
  let(:Authorization) { ENV['SERVICE_ACCESS_KEY'] }

  before do
    create(:location, ip: '192.1.1.1')
    create(:location, ip: '192.1.1.1')
    create(:location, ip: '192.1.1.1')
    create(:location, ip: '192.1.1.2')
    create(:location, ip: '192.1.1.3')
    create(:location, url: 'www.positrace.com')
    create(:location, url: 'www.positrace.com')
    create(:location, url: 'www.example.com')
  end

  path '/api/v1/locations' do
    get 'Retrieve locations' do
      tags 'Locations'

      produces 'application/json'

      security [ApiKeyAuth: []]

      parameter name: :ip, in: :query, type: :string
      parameter name: :url, in: :query, type: :string

      context 'with valid arguments' do
        response '200', 'location found' do
          schema type: :object,
                properties: {
                  data: {
                    type: :array,
                    items: {
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
                  meta: {
                    type: :object,
                    properties: {
                      total_pages: { type: :integer },
                      records: { type: :integer },
                      current_page: { type: :integer }
                    },
                    required: %i[total_pages records current_page]
                  }
                },
                required: %i[data meta]

          context 'without filter param' do
            run_test! do |response|
              data = JSON.parse(response.body)
              expect(data['data'].count).to eq(8)
            end
          end

          context 'with an ip as filter param' do
            let(:ip) { '192.1.1.1' }

            run_test! do |response|
              data = JSON.parse(response.body)
              expect(data['data'].count).to eq(3)
            end
          end

          context 'with an url as filter param' do
            let(:url) { 'www.positrace.com' }

            run_test! do |response|
              data = JSON.parse(response.body)
              expect(data['data'].count).to eq(2)
            end
          end
        end
      end

      context 'with invalid arguments' do
        response '401', 'not authorized' do
          let(:Authorization) { 'invalid-token' }

          run_test!
        end
      end
    end
  end
end
