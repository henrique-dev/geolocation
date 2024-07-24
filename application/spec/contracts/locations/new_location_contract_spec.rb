require 'rails_helper'

RSpec.describe Locations::NewLocationContract, type: :contract do
  let(:location_params) { attributes_for(:location) }

  subject do
    described_class.call(location_params)
  end

  context 'with valid arguments' do
    it 'not have errors validating a contract' do
      expect(subject).to match({
        ip: location_params[:ip],
        url: location_params[:url]
      })
    end
  end

  context 'with invalid arguments' do
    context 'without ip and url' do
      let(:location_params) { {} }

      it 'have errors validating a contract' do
        expect do
          subject
        end.to raise_exception(Errors::ServiceError)
      end
    end

    context 'with an invalid ip' do
      let(:location_params) { { ip: 'invalid-ip' } }

      it 'have errors validating a contract' do
        expect do
          subject
        end.to raise_exception(Errors::ServiceError)
      end
    end

    context 'with an invalid url' do
      let(:location_params) { { url: 'url.with space' } }

      it 'have errors validating a contract' do
        expect do
          subject
        end.to raise_exception(Errors::ServiceError)
      end
    end
  end
end
