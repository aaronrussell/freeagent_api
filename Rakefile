require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "freeagent_api"
    gem.summary = %Q{ActiveResource Ruby wrapper for the Freeagent Central API.}
    gem.description = %Q{This is an ActiveResource Ruby wrapper for the Freeagent API. Currently supports the following API resources: Company, Contacts, Projects, Tasks, Invoices, Invoice Items, Timeslips (more will follow).}
    gem.email = "aaron@gc4.co.uk"
    gem.homepage = "http://github.com/aaronrussell/freeagent_api"
    gem.authors = ["Aaron Russell"]
    gem.add_development_dependency "thoughtbot-shoulda"
    gem.add_development_dependency "fakeweb"
    gem.add_dependency "activeresource"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "freeagent_api #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
