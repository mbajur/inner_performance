# frozen_string_literal: true

require_relative 'lib/inner_performance/version'

Gem::Specification.new do |spec|
  spec.name        = 'inner_performance'
  spec.version     = InnerPerformance::VERSION
  spec.authors     = ['mbajur']
  spec.email       = ['mbajur@gmail.com']
  spec.homepage    = 'https://github.com/mbajur'
  spec.summary     = 'Database-backed modest performance monitoring tool for your Rails app.'
  spec.description = 'Database-backed modest performance monitoring tool for your Rails app.'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/mbajur/inner_performance'
  spec.metadata['changelog_uri'] = 'https://github.com/mbajur/inner_performance'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'activejob', '>= 7.1.5'
  spec.add_dependency 'pagy', '>= 9.3.1'
  spec.add_dependency 'rails', '>= 7.1.5'
  spec.add_dependency 'ransack', '>= 4.2.1'

  spec.add_development_dependency 'rspec-rails'
end
