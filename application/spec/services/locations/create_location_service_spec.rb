require 'rails_helper'

RSpec.describe Locations::CreateLocationService, type: :service, vcr: { match_requests_on: %i[host path] } do
  let(:location) { Location.new }
  let(:params) { {} }

  subject do
    described_class.call(params:)
  end

  context 'with valid arguments' do
    context 'with an url as ip_or_url' do
      let(:params) { { url: 'www.positrace.com' } }

      it 'not have errors creating a location' do
        expect(subject.errors).to eq({})
        expect(subject.success).to eq(true)
        expect(Location.address_is_ip?(subject.object.ip)).to eq(true)
        expect(subject.object.url).to eq(params[:url])
        expect(subject.object.kind).to_not be_nil
        expect(subject.object.continent_code).to_not be_nil
        expect(subject.object.continent_name).to_not be_nil
        expect(subject.object.country_code).to_not be_nil
        expect(subject.object.country_name).to_not be_nil
        expect(subject.object.region_code).to_not be_nil
        expect(subject.object.region_name).to_not be_nil
        expect(subject.object.city).to_not be_nil
        expect(subject.object.zip).to_not be_nil
        expect(subject.object.latitude).to_not be_nil
        expect(subject.object.longitude).to_not be_nil
        expect(subject.object.location).to_not be_nil
        expect(subject.object.time_zone).to_not be_nil
        expect(subject.object.currency).to_not be_nil
      end

      it 'create a location' do
        expect do
          subject
        end.to change(Location, :count).by(1)
      end
    end

    context 'with an ip as ip_or_url' do
      let(:params) { { ip: '134.201.250.155' } }

      it 'not have errors creating a location' do
        expect(subject.errors).to eq({})
        expect(subject.success).to eq(true)

        expect(subject.object.ip).to eq(params[:ip])
        expect(subject.object.url).to be_nil
        expect(subject.object.kind).to_not be_nil
        expect(subject.object.continent_code).to_not be_nil
        expect(subject.object.continent_name).to_not be_nil
        expect(subject.object.country_code).to_not be_nil
        expect(subject.object.country_name).to_not be_nil
        expect(subject.object.region_code).to_not be_nil
        expect(subject.object.region_name).to_not be_nil
        expect(subject.object.city).to_not be_nil
        expect(subject.object.zip).to_not be_nil
        expect(subject.object.latitude).to_not be_nil
        expect(subject.object.longitude).to_not be_nil
        expect(subject.object.location).to_not be_nil
        expect(subject.object.time_zone).to_not be_nil
        expect(subject.object.currency).to_not be_nil
      end

      it 'create a location' do
        expect do
          subject
        end.to change(Location, :count).by(1)
      end
    end
  end

  context 'with invalid arguments' do
    context 'when the provider fill the location with a wrong data' do
      let(:params) { { url: 'www.positrace.com' } }

      before do
        allow_any_instance_of(ServiceResponse).to receive(:object).and_return(Location.new)
      end

      it 'have errors creating a location' do
        expect(subject.errors).to eq({ location: ['could not create the location'] })
        expect(subject.success).to eq(false)
      end

      it 'not create a location' do
        expect do
          subject
        end.to change(Location, :count).by(0)
      end
    end

    context 'without ip and url' do
      let(:params) { {} }

      it 'have errors creating a location' do
        expect(subject.errors).to eq({ ip_or_url: ['ip or url must be filled'] })
        expect(subject.success).to eq(false)
      end

      it 'not create a location' do
        expect do
          subject
        end.to change(Location, :count).by(0)
      end
    end

    context 'with an invalid ip' do
      let(:params) { { ip: 'invalid-ip' } }

      it 'have errors creating a location' do
        expect(subject.errors).to eq({ ip: ['is not valid'] })
        expect(subject.success).to eq(false)
      end

      it 'not create a location' do
        expect do
          subject
        end.to change(Location, :count).by(0)
      end
    end

    context 'with an invalid url' do
      let(:params) { { url: 'url.with space' } }

      it 'have errors creating a location' do
        expect(subject.errors).to eq({ url: ['is not valid'] })
        expect(subject.success).to eq(false)
      end

      it 'not create a location' do
        expect do
          subject
        end.to change(Location, :count).by(0)
      end
    end
  end
end
