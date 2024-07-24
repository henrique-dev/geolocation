RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner[:active_record].clean_with :truncation, except: %w[ar_internal_metadata]
    Rails.application.load_seed
  end

  config.before(:each) do
    DatabaseCleaner[:active_record].strategy = :transaction
  end

  config.before(:each, type: :system) do
    DatabaseCleaner[:active_record].strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner[:active_record].start
  end

  config.after(:each) do
    DatabaseCleaner[:active_record].clean
  end
end
