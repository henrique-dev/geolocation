require 'rails_helper'

RSpec.describe Locations::DestroyLocationService, type: :service do
  let!(:location) { create(:location) }

  subject do
    described_class.call(location:)
  end

  context 'with valid arguments' do
    it 'not have errors destroying a location' do
      expect(subject.errors).to eq({})
      expect(subject.success).to eq(true)
    end

    it 'destroy a location' do
      expect do
        subject
      end.to change(Location, :count).by(-1)
    end
  end

  context 'with invalid arguments' do
  end
end
