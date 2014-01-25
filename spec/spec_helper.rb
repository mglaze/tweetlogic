# encoding: utf-8
#
# Copyright:: Copyright (c) 2008-2012, SweetSpot Diabetes Care, Inc.
# License::   All rights reserved
#

# This file is copied to spec/ when you run 'rails generate rspec:install'
puts <<-MSG

/*******************************************************************
        Software Pakcage : #{File.basename(`pwd`.strip)}
        Current Dir      : #{Dir.pwd}
        Current Time     : #{Time.now}
        # Git Branch       : #{`git rev-parse --abbrev-ref HEAD`.strip}
        # Git Version      : #{`git rev-parse HEAD`.strip}
*******************************************************************/



MSG

ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
ActiveSupport::Deprecation.silenced = true

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run_excluding :slow, :performance

  #NOTE: these HAVE to be set to what we need... rspec has the order wrong in that the support files are loaded first, which means we can't overload these values!
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = nil #"#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
end

