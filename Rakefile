require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "assembla"
    gemspec.summary = "Command line access to assembla"
    gemspec.description = "This gem provides access to assembla tickets. It supports listing, creating and modyfing functionality"
    gemspec.email = "imoryc@gmail.com"
    gemspec.homepage = "http://github.com/ignacy/assembla"
    gemspec.authors = ["Ignacy Moryc"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

############################

require 'spec/rake/spectask'

desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts = ['--colour --format progress --loadby mtime --reverse']
  t.spec_files = FileList['spec/*_spec.rb']
end

desc "Print specdocs"
Spec::Rake::SpecTask.new(:doc) do |t|
  t.spec_opts = ["--format", "specdoc", "--dry-run"]
  t.spec_files = FileList['spec/*_spec.rb']
end

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new('rcov') do |t|
  t.spec_files = FileList['spec/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'examples']
end

task :default => :spec

############################

require 'rake/rdoctask'

Rake::RDocTask.new do |t|
  t.rdoc_dir = 'rdoc'
  t.title = "assembla, command line assembla.com client"
  t.options << '--line-numbers' << '--inline-source' << '-A cattr_accessor=object'
  t.options << '--charset' << 'utf-8'
  t.rdoc_files.include('README.textile')
  t.rdoc_files.include('lib/assembla.rb')
end

