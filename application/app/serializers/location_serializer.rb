class LocationSerializer
  include JSONAPI::Serializer

  attributes :ip, :url, :kind, :continent_code, :continent_name, :country_code, :country_name, :region_code,
             :region_name, :city, :zip, :latitude, :longitude, :location, :time_zone, :currency, :created_at, :updated_at
end
