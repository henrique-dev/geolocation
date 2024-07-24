class Location < ApplicationRecord
  serialize :location, coder: JSON, type: Hash
  serialize :time_zone, coder: JSON, type: Hash
  serialize :currency, coder: JSON, type: Hash

  validates_presence_of :ip, :kind, :continent_code, :continent_name, :country_code, :country_name, :region_code,
                        :region_name, :city, :zip, :latitude, :longitude

  def self.address_is_ip?(address)
    !(address =~ Resolv::AddressRegex).nil?
  end

  def self.address_is_url?(address)
    URI.parse(address)
  rescue URI::InvalidURIError
    false
  end
end
