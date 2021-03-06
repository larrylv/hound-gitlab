$: << File.expand_path("../..", __FILE__)

require "attr_extras"
require "byebug"
require "webmock/rspec"
require "active_support"
require "active_support/core_ext"

Dir["spec/support/**/*.rb"].each { |f| require f }

ENV["HOST"] = "test.host"
ENV["SECRET_KEY_BASE"] = "test-key"
ENV["HOUND_GITHUB_USERNAME"] = "houndci"
ENV["HOUND_GITHUB_TOKEN"] = "houndgithubtoken"
ENV["ENABLE_HTTPS"] = "no"
ENV["CHANGED_FILES_THRESHOLD"] = "300"
ENV["EXEMPT_ORGS"] = "thoughtbot,billybob"

RSpec.configure do |config|
  config.order = "random"
  config.include GithubApiHelper
  WebMock.disable_net_connect!(allow_localhost: true)
end
