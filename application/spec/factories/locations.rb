FactoryBot.define do
  factory :location, class: 'Location' do
    ip { Faker::Internet.public_ip_v4_address }
    url { Faker::Internet.domain_name }
    kind { %w[ipv4 ipv6].sample }
    continent_code { Faker::Address.time_zone }
    continent_name { Faker::Address.time_zone }
    country_code { Faker::Address.country_code }
    country_name { Faker::Address.country }
    region_code { Faker::Address.state_abbr }
    region_name { Faker::Address.state }
    city { Faker::Address.city }
    zip { Faker::Address.zip_code }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    location do
      {
        geoname_id: 5_392_171,
        capital: 'Washington D.C.',
        languages: {
          code: 'en',
          name: 'English',
          native: 'English'
        },
        country_flag: 'https://assets.ipstack.com/flags/us.svg',
        country_flag_emoji: '🇺🇸',
        country_flag_emoji_unicode: 'U+1F1FA U+1F1F8',
        calling_code: '1',
        is_eu: false
      }
    end
    time_zone do
      {
        id: 'America/Los_Angeles',
        current_time: '2024-07-23T21:08:27-07:00',
        gmt_offset: -25_200,
        code: 'PDT',
        is_daylight_saving: true
      }
    end
    currency do
      {
        code: 'USD',
        name: 'US Dollar',
        plural: 'US dollars',
        symbol: '$',
        symbol_native: '$'
      }
    end
  end
end
