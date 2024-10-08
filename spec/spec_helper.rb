# frozen_string_literal: true

require 'dotenv/load'
require 'factory_bot'
require 'ffaker'
require 'fileutils'
require 'pry-byebug'
require 'securerandom'
require 'tempfile'
require 'time'
require 'yaml'

require_relative 'support/custom_matchers'

require 'simplecov'

SimpleCov.start do
  add_filter 'spec'
end

if File.exist?('.env.test')
  # This loads our test environment when running tests.
  require 'dotenv'
  Dotenv.load('.env.test')
end

require 'doto'
Dir[File.join(Dir.pwd, 'lib/migrate/**/*.rb')].each { |f| require f }
Dir[File.join(Dir.pwd, 'spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # FactoryBot
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
    Time.zone = 'Eastern Time (US & Canada)'
  end

  config.around do |example|
    Time.use_zone(Time.zone) do
      example.run
    end
  end

  config.include ColorThemeHelpers
  config.include DescriptionStringHelpers
  config.include MockMigrationVersionHepers, type: :migration
  config.include ProjectHelpers
  config.include StdxxxHelpers
  config.include TimeHelpers
end
