require "rspec/core/rake_task"
require "chefstyle"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new("spec")
task default: :spec

RuboCop::RakeTask.new(:style) do |task|
  task.options << "--display-cop-names"
end
