module Locations
  class NewLocationContract < ApplicationContract
    params do
      optional(:ip).filled(:string)
      optional(:url).filled(:string)
    end

    rule(:ip, :url) do
      key(:address).failure('ip or url must be filled') if values[:ip].nil? && values[:url].nil?
    end

    rule(:ip) do
      next if value.nil?

      key.failure('is not valid') unless Location.address_is_ip?(value)
    end

    rule(:url) do
      next if value.nil?

      key.failure('is not valid') unless Location.address_is_url?(value)
    end
  end
end
