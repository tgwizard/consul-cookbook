require 'chefspec'
require 'chefspec/berkshelf'
require 'coveralls'

Coveralls.wear!

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '12.04'

  config.color = true
  config.alias_example_group_to :describe_recipe, type: :recipe
  config.alias_example_group_to :describe_resource, type: :resource

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  Kernel.srand config.seed
  config.order = :random

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end

at_exit { ChefSpec::Coverage.report! }

RSpec.shared_context 'recipe tests', type: :recipe do
  before do
    stub_command("test -L /usr/local/bin/consul").and_return(true)
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.converge(described_recipe)
  end
end

RSpec.shared_context 'resource tests', type: :resource do
  before do
    stub_command("test -L /usr/local/bin/consul").and_return(true)
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_info: [described_resource]).converge(cookbook_name)
  end
end
