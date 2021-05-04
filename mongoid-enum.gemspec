# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'mongoid/enum/version'

Gem::Specification.new do |spec|
  spec.version       = if ENV['GITHUB_REF'].eql?('refs/heads/develop')
                         "#{Mongoid::Enum::VERSION}.pre.#{ENV['GITHUB_RUN_ID']}"
                       else
                         Mongoid::Enum::VERSION
                       end
  spec.name          = Mongoid::Enum::GEM_NAME
  spec.authors       = Mongoid::Enum::AUTHORS
  spec.email         = Mongoid::Enum::EMAILS

  spec.summary       = Mongoid::Enum::SUMMARY
  spec.description   = Mongoid::Enum::DESCRIPTION

  spec.homepage      = Mongoid::Enum::HOMEPAGE
  spec.license       = Mongoid::Enum::LICENSE

  spec.files         = ['Gemfile', 'LICENSE', 'Rakefile', 'README.md']
  spec.files         += Dir['lib/**/*']
  spec.files         += Dir['spec/**/*']

  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6.0'

  spec.add_development_dependency 'bundler', '~> 2.2', '<= 2.2.16'
  spec.add_development_dependency 'faker', '~> 2.17'
  spec.add_development_dependency 'mongoid-rspec', '~> 4.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.3'
  spec.add_development_dependency 'reek', '~> 6.0.4'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop', '~> 1.13.0'
  spec.add_development_dependency 'rubocop-faker', '~> 1.1'
  spec.add_development_dependency 'rubocop-performance', '~> 1.11', '>= 1.11.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.3'
  spec.add_development_dependency 'simplecov', '~> 0.21.2'
  spec.add_development_dependency 'simplecov_json_formatter', '~> 0.1.3'

  spec.add_dependency 'mongoid', '~> 7.2', '>= 7.2.2'
end
