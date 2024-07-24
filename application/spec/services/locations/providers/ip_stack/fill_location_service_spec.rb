require 'rails_helper'

RSpec.describe Locations::Providers::IpStack::FillLocationService, type: :service, vcr: { match_requests_on: %i[host path] } do
  let(:location) { Location.new }
  let(:ip_or_url) { nil }

  subject do
    described_class.call(location:, ip_or_url:)
  end

  context 'with valid arguments' do
    context 'with an url as ip_or_url' do
      let(:ip_or_url) { 'www.positrace.com' }

      it 'not have errors creating a location' do
        expect(subject.errors).to eq({})
        expect(subject.success).to eq(true)
        expect(Location.address_is_ip?(subject.object.ip)).to eq(true)
        expect(subject.object.url).to eq(ip_or_url)
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
    end

    context 'with an ip as ip_or_url' do
      let(:ip_or_url) { '134.201.250.155' }

      it 'not have errors creating a location' do
        expect(subject.errors).to eq({})
        expect(subject.success).to eq(true)

        expect(Location.address_is_ip?(subject.object.ip)).to eq(true)
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
    end
  end

  context 'with invalid arguments' do
    context 'when the provider is unavailable' do
      before do
        allow(Locations::Providers::IpStack::DataProvider).to receive(:get).and_raise(StandardError)
      end

      it 'have errors filling geolocation data' do
        expect(subject.errors).to eq({ provider: ['unable to establish the connection'] })
        expect(subject.success).to eq(false)
      end
    end
  end
end
