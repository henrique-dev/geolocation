class Location < ApplicationRecord
  serialize :location, coder: JSON, type: Hash
  serialize :time_zone, coder: JSON, type: Hash
  serialize :currency, coder: JSON, type: Hash

  validates_presence_of :ip, :kind, :continent_code, :continent_name, :country_code, :country_name, :region_code,
                        :region_name, :city, :zip, :latitude, :longitude

  scope :from_ip, ->(ip) { where(ip:) }
  scope :from_url, ->(url) { where(url:) }

  def self.address_is_ip?(address)
    !(address =~ Resolv::AddressRegex).nil?
  end

  def self.address_is_url?(address)
    URI.parse(address)
  rescue URI::InvalidURIError
    false
  end

  def self.current
    order(created_at: :desc).first
  end

  def self.filter_by(params)
    filter_params = {}

    filter_params.merge!({ url: params[:url] }) if params[:url].present?
    filter_params.merge!({ ip: params[:ip] }) if params[:ip].present?

    if params.empty?
      all
    else
      where(filter_params)
    end
  end
end
