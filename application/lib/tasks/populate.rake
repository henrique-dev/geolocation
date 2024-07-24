# rubocop:disable Metrics/BlockLength
namespace :db do
  def create_location
    Location.create!(
      ip: Faker::Internet.public_ip_v4_address,
      url: Faker::Internet.domain_name,
      kind: %w[ipv4 ipv6].sample,
      continent_code: Faker::Address.time_zone,
      continent_name: Faker::Address.time_zone,
      country_code: Faker::Address.country_code,
      country_name: Faker::Address.country,
      region_code: Faker::Address.state_abbr,
      region_name: Faker::Address.state,
      city: Faker::Address.city,
      zip: Faker::Address.zip_code,
      latitude: Faker::Address.latitude,
      longitude: Faker::Address.longitude
    )
  rescue StandardError
    nil
  end

  desc 'Populate the database with some data'
  task populate: :environment do
    unless Rails.env.production?
      ActiveRecord::Base.logger = nil
      Faker::UniqueGenerator.clear

      100.times do
        create_location
      end

      puts '100 locations were created'
    end
  end
end
# rubocop:enable Metrics/BlockLength
