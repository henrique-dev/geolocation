require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:location_params) { attributes_for(:location) }

  subject do
    described_class.new(location_params)
  end

  context 'with valid arguments' do
    it 'is a valid object' do
      expect(subject).to be_valid
    end

    it 'create a location' do
      expect do
        subject.save
      end.to change(Location, :count).by(1)
    end

    it 'destroy a location' do
      subject.save
      expect do
        subject.destroy
      end.to change(Location, :count).by(-1)
    end

    it 'without url is a valid object' do
      location_params.delete(:url)
      expect(subject).to be_valid
    end

    it 'without location is a valid object' do
      location_params.delete(:location)
      expect(subject).to be_valid
    end

    it 'without time_zone is a valid object' do
      location_params.delete(:time_zone)
      expect(subject).to be_valid
    end

    it 'without currency is a valid object' do
      location_params.delete(:currency)
      expect(subject).to be_valid
    end
  end

  context 'with invalid arguments' do
    it 'without ip is not a valid object' do
      location_params.delete(:ip)
      expect(subject).to_not be_valid
    end

    it 'without kind is not a valid object' do
      location_params.delete(:kind)
      expect(subject).to_not be_valid
    end

    it 'without continent_code is not a valid object' do
      location_params.delete(:continent_code)
      expect(subject).to_not be_valid
    end

    it 'without continent_name is not a valid object' do
      location_params.delete(:continent_name)
      expect(subject).to_not be_valid
    end

    it 'without country_code is not a valid object' do
      location_params.delete(:country_code)
      expect(subject).to_not be_valid
    end

    it 'without country_name is not a valid object' do
      location_params.delete(:country_name)
      expect(subject).to_not be_valid
    end

    it 'without region_code is not a valid object' do
      location_params.delete(:region_code)
      expect(subject).to_not be_valid
    end

    it 'without region_name is not a valid object' do
      location_params.delete(:region_name)
      expect(subject).to_not be_valid
    end

    it 'without city is not a valid object' do
      location_params.delete(:city)
      expect(subject).to_not be_valid
    end

    it 'without zip is not a valid object' do
      location_params.delete(:zip)
      expect(subject).to_not be_valid
    end

    it 'without latitude is not a valid object' do
      location_params.delete(:latitude)
      expect(subject).to_not be_valid
    end

    it 'without longitude is not a valid object' do
      location_params.delete(:longitude)
      expect(subject).to_not be_valid
    end
  end
end
