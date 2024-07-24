require 'simplecov'
SimpleCov.start

# Don't print the "Coverage report generated for..." messages
# https://github.com/simplecov-ruby/simplecov/issues/992
SimpleCov.at_exit do
  original_file_descriptor = $stdout
  $stdout.reopen('/dev/null')
  SimpleCov.result.format!
  $stdout.reopen(original_file_descriptor)
end
