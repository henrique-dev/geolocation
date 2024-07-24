RSpec.configure do |config|
  config.after(:all) do
    Faker::UniqueGenerator.clear
  end
end
