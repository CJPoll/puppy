require('rspec/core/rake_task')

#RSpec::Core::RakeTask.new(:spec)

task :run do
	ruby %{-I ./src src/main.rb}
end

task :test do
	puts `rspec -I ./src`
end

task :default => :run
