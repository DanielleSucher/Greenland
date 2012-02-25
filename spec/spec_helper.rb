RSpec.configure do |config|
	config.mock_with :rspec
   	config.fixture_path = "#{::Rails.root}/spec/fixtures"

   	config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
  	
  	config.include Capybara::DSL
end